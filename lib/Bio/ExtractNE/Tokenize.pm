package Bio::ExtractNE::Tokenize;

use strict;
use YAML;
use Exporter::Lite;
use Regexp::Common;
use Storable qw(dclone);
use Bio::ExtractNE::Vars;
use Quantum::Superpositions;
use Bio::ExtractNE::SplitSentence;

our @EXPORT = qw(tokenize);


# Over-split tokens need to be merged together.
# for example, things like '(n' '=' '3)' need to be merged to '(n = 3)'
sub _bracket_stat {
    my $str = shift;
    my %stat;
    while($str =~ m,([\(\)\[\]]),go){
	$stat{$1} = 1;
    }
    \%stat;
}

sub _is_balanced {
    my $stat = shift;
    my $balanced = 1;
    $balanced = 0 if $stat->{')'} - $stat->{'('};
    $balanced = 0 if $stat->{']'} - $stat->{'['};
    $balanced;
}

sub _merge_tokens {
    my $self = shift;
    my $sentence_number = shift;
    my $token_ref = $self->{token_ref}->[$sentence_number];

    my $state = 0;
    my $start_idx = 0;
    my $end_idx = 0;
    my $laststat = {};
    my $token;
    for (my $i = 0; $i<=$#$token_ref; ){
	$token = $token_ref->[$i];
	if($state == 0){
	    if($token =~ m,[\(\[],o){
		my $stat = _bracket_stat($token);
		if(!_is_balanced($stat)){
		    $start_idx = $i;
		  $laststat = dclone $stat;
		    $state = 1;
		}
	    }
	}
	elsif($state == 1){
	    if($token =~ m,[\(\)\[\]],o ){
		my $stat = _bracket_stat($token);
		if($token =~ m,[\)\]],o){
		    foreach my $c (keys %$laststat){
			$laststat->{$c} -= $stat->{$counterpart{$c}};
		    }
		}
		elsif($token =~ m,[\(\[],o){
		    foreach my $c (keys %$laststat){
			$laststat->{$c} += $stat->{$counterpart{$c}};
		    }
		}

	    }
	    if ( all(values %$laststat) == 0 ){
		$end_idx = $i;
		$state = 2;
	    }
	}
	if($state == 2){
	    $token_ref->[$start_idx] =
		join q/ /, @{$token_ref}[$start_idx..$end_idx];
	    @{$token_ref}[$start_idx+1..$end_idx] = ();
	    $state = 0;
	    $i = $start_idx + 1;
	}
	else {
	    $i++;
	}
    }
    @{$token_ref} = grep{$_} @{$token_ref};
}

# split again over-merged tokens
sub _split_tokens {
    my $self = shift;
    my $sentence_number = shift;
    my $token_ref = $self->{token_ref}->[$sentence_number];

    for(my $i = 0; $i <$#$token_ref; ){
	if($token_ref->[$i] =~ /$RE{balanced}{-parens=>'()'}/){
	    if(my $t = ($token_ref->[$i]=~ /^\((.+)\)/o, $1)){
#		print "$t\n";
		my @subt = split / /, $t;
#		print "@subt$/";
		@$token_ref =
		    (@{$token_ref}[0..$i-1],
		     '(', @subt, ')',
		     @{$token_ref}[$i+@subt..$#$token_ref]);
#		print ">>" , $token_ref->[$i].$/;
		$i+=scalar(@subt);
		next;
	    }
	}
	$i++;
    }
}



sub tokenize {
    my ($self, $text_ref) = @_;
    my $sentence_ref = split_sentence($text_ref);
    my $token_ref = [];
    my $sentence_number = 0;

    $self->{token_ref} = $token_ref;
    $self->{sentence_ref} = $sentence_ref;

    foreach my $s (@$sentence_ref){
      while($s =~ /(.+?)(?:\s+|$)/go){
	  my $tok = $1;
	  my $tok2 = $2 if $tok =~ s/^(.+)([,\.])$/$1/o;
	  push @{$token_ref->[$sentence_number]}, $tok;
	  push @{$token_ref->[$sentence_number]}, $tok2 if $tok2;
      }
      $self->_merge_tokens($sentence_number);
      $self->_split_tokens($sentence_number);
      $sentence_number++;

    }
    $token_ref;
}



1;
__END__
