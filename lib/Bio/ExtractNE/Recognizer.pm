package Bio::ExtractNE::Recognizer;

use strict;

use YAML;
use Regexp::Common;
use Bio::ExtractNE::Vars;
use List::Util qw(reduce);
use Quantum::Superpositions;
use Bio::ExtractNE::Stoplist;
use Bio::ExtractNE::EventPattern;


##################################################
# I have to admit that this module is super gross.
##################################################

sub _get_counterpart_idx {
    my ($ref, $idx) = @_;
    for (my $i = $idx+1; $i<@$ref; $i++){
	return $i if $ref->[$i] eq ')';
    }
}


sub _get_affix_initial {
    my $word = shift;
    my %affix;
    while($word =~ s/($affix_pattern)//go){
	$affix{lc substr($1, 0, 1)}++;
    }
    %affix;
}

# Retrieve the contextual meanings of abbreviations.
# e.g. cytochrome P450 (CYP)
# The basic assumption about abbreviations is that they are initialed with
# capital letter and are followed by a alphanumeric letters.
# and there is no space in abbrev words
my $abbrev_pattern = qr'^[A-Z][A-Za-z0-9]+$';
sub _get_abbrref {
    my $self = shift;
    my $token_ref = $self->{token_ref};
    my $NE_ref = $self->{NE_ref};
    my $EXP_ref = $self->{abbr_expansion};
    my $location_ref = $self->{location_ref};

    foreach my $sentence_number (0..$#$token_ref){
	my $tokens = $token_ref->[$sentence_number];
        for( my $i = 0; $i < @$tokens; ){
            my $tok = $tokens->[$i];
	    if($tok eq '('){
		my $t =
		    join q/ /,
		    @{$tokens}[$i+1.._get_counterpart_idx($tokens, $i)-1];
		my @char = split //o, $t;

		# still needs some better back-looking mechanism
		if( $t =~ /$abbrev_pattern/o ){
#		    print "<@char>$/";
		    my $is_abbrev = 1;
		    foreach (my $j = $i-@char, my $k=0; $j<$i; $j++, $k++){
#			print "$j ";
#			print $tokens->[$j].$/;
			if($tokens->[$j] !~ /^$char[$k]/i){
			    $is_abbrev = 0;
			    last;
			}
		    }
		    
		    if($is_abbrev){
			$NE_ref->{$t} = 1;
			my $fullname = join q/ /, @{$tokens}[$i-@char..$i-1];
			$NE_ref->{$fullname} = 1;
			$EXP_ref->{$t} = $fullname;
			$location_ref->[$sentence_number]->{$fullname} = $i-@char;
		    }
		    else {
			# try to break into affixes
			my %hash;
			my $left_margin;
			    
			$is_abbrev = 0;
			for(my $j = $i-1; $j>=$i-@char; $j--){
			    %hash = (%hash, _get_affix_initial($tokens->[$j]));
			    foreach my $c (@char){
				 $hash{lc $c}--;
			    }
			    if( all( values %hash) == 0 ){
				$is_abbrev = 1;
				$left_margin = $j;
				last;
			    }
			}


			if($is_abbrev){
			    $NE_ref->{$t} = 1;
			    my $fullname = join ' ', @{$tokens}[$left_margin..$i-1];
			    $NE_ref->{$fullname} = 1;
			    $EXP_ref->{$t} = $fullname;
			    $location_ref->[$sentence_number]->{$fullname} = $i-@char;
			}

			# or if the abbreviation does not match all the initials
			# then it will break the letter into a hash	
			# a little dumb, but workable in cases.
			# THE LAST STRATEGY.
			else {
			    my %hash;
			    for(my $j = $i-1; $j>=$i-@char; $j--){
				$hash{lc $_} = 1 for split //, $tokens->[$j];
				$is_abbrev = 1;
				foreach (@char){
				    $is_abbrev = 0 if !$hash{lc $_};
				}
				if($is_abbrev){
				    $NE_ref->{$t} = 1;
				    my $fullname = join q/ /, @{$tokens}[$j..$i-1];
				    $NE_ref->{$fullname} = 1;
				    $EXP_ref->{$t} = $fullname;
				    $location_ref->[$sentence_number]->{$fullname} = $j;
				    last;
				}
			    }
			}
		    }
		}

		$i=_get_counterpart_idx($tokens, $i)+1;
	    }
	    else {
		$i++;
	    }
	}
    }
}


# retrieve NE from compound words
sub _get_from_compound {
    my $self = shift;
    my $token_ref = $self->{token_ref};
    my $NE_ref = $self->{NE_ref};
    my $dict = $self->{dict};

    foreach my $tokens (@$token_ref){
        for( my $i = 0; $i < @$tokens; ){
            my $tok = $tokens->[$i];
	    if(my($p, $k) = ($tok =~ /(.+)\-(.+)$/, $1, $2)){
	      if($k =~ /$event_pattern/o){
		$NE_ref->{$p} = 1 if $dict->query($p);
	      }
	    }
	    $i++;
	}
    }
}

# transform 'cytochrome P450 (CYP)' into 'CYP'
sub _abridge_tokens {
    my $self = shift;
    my $token_ref = $self->{token_ref};
    my $NE_ref = $self->{NE_ref};
    my $location_ref = $self->{location_ref};


    foreach my $sentence_number (0..$#$location_ref){
      foreach my $fullname (keys %{$location_ref->[$sentence_number]}){
	my $fullname_length = split/ /, $fullname;
	my $offset = $location_ref->[$sentence_number]->{$fullname};
	for my $t ($offset..$offset+$fullname_length){
	  undef $token_ref->[$sentence_number]->[$t];
	}
	undef $token_ref->[$sentence_number]->[$offset+$fullname_length+2];
      }
      @{$token_ref->[$sentence_number]} =
	  grep {$_} @{$token_ref->[$sentence_number]};
    }
}

sub _detect_events {
    my $token_ref = shift;
    my @valid;
    foreach my $sentence_number (0..$#{$token_ref}){
	foreach my $t (@{$token_ref->[$sentence_number]}){
	    if( $t =~ /\b$event_pattern\b/io ) {
		push @valid, $sentence_number;
		last;
	    }
	}
    }
    \@valid;
}


sub recognizer {
    my ($self) = shift;
    my $token_ref = $self->{token_ref};
    my $dict = $self->{dict};

    $self->{NE_ref} = {};
    $self->{location_ref} = [];
    $self->{abbr_expansion} = {},

    my $NE = $self->{NE_ref};

    $self->_get_abbrref();
    $self->_get_from_compound();

    foreach my $tokens (@$token_ref){
	# iterate through the tokens from each sentence
	for( my $i = 0; $i < @$tokens; ){
	    my $tok = $tokens->[$i];

	    # if the word has been recognized in previous steps
	    # then, increase its count
	    if($NE->{$tok}){
		$NE->{$tok}++;
	    }

	    # or if the word occurs in head-word database
	    # otherwise, skip it.
	    elsif($dict->query(lc($tok), 'hw')){
		my $max_length = $dict->query(lc($tok), 'ml');
		foreach my $len (reverse 1..$max_length){
		    my $expanded = join q/ /, @{$tokens}[$i..$i+$len-1];
		    if($dict->query(lc($expanded), 'lc')){
			next if $stopword{lc $expanded};
			next if $expanded =~ /$RE{num}{real}/o;
			$NE->{$expanded}++;
			last;
		    }
		}
	    }

            # or if the word belongs to the CYP or caspase family
	    # It is VERY BAD to write this in module,
	    # but CYP is so common that I guess I can write it here.
            elsif ($tok =~ /^(?:CYP[A-Z\d]+|[Cc]aspase-\d+)$/){
                $NE->{$tok}++;
            }

	    # probably chemical elements
	    elsif ($tok =~ /^[A-Z]\w+\(\d+?\+\)$/){
                $NE->{$tok}++;
	    }

	    $i++;
	}
    }


    $self->_abridge_tokens();
    {
	token => $token_ref,     # abridged version of tokens
	NE => [ sort { $NE->{$b} <=> $NE->{$a} } keys %$NE ],
	with_interaction => _detect_events($token_ref),
	abbr_expansion => $self->{abbr_expansion},
    }
}


1;
__END__
