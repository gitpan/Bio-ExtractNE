package Bio::ExtractNE::MakeDict;

use strict;
use YAML;
use DB_File;
use List::Util;
use Exporter::Lite;
use Bio::ExtractNE::Dict;
use Bio::ExtractNE::Vars;
use Bio::ExtractNE::Stoplist;
use Regexp::Common qw/balanced/;

our @EXPORT = qw(mkdict mkcwdict);

sub ext_GN {
    my $text = shift;
    my @name;
    while($text =~ /^GN   Name=(.+?);(?: Synonyms=(.+?);)?/mg){
	push @name, split(/, / => $1), split(/, / => $2);
    }
    @name;
}

sub eliminate_precursor {
    my $t = shift;
    $t =~ s/(.+?)\s+precursor\b/$1/o;
    $t =~ s/\s$//o;
    $t;
}

sub ext_DE {
    my $text = shift;
    my @name;
    my $de;
    $de .= $1 while $text=~ /^DE   (.+?)$/mgo;
    $de =~ s/\.$//o;
#    chop $de;
    $de =~ s{($RE{balanced}{-parens=>'[]'})}{my $g=$&;
					     $g =~ /\[\w+?:/o ? '' : $g}gex;
    $de =~ s/\((?:EC (?:(?:\d+|-)\.){3}(?:\d+|-)|Fragments?|Putative replicase)\)//go;

    if($de =~ /^(.+?) \(/o){
	push @name, eliminate_precursor($1);
	while($de =~ /($RE{balanced}{-parens=>'()'})/go){
	    (my $t=$1)=~ s/\((.+)\)/$1/o;
	    next if $t =~ /[()]/o && !/$RE{balanced}{-parens=>'()'}/o;
	    next if $t =~ /[\[\]]/o && !/$RE{balanced}{-parens=>'[]'}/o;
	    push @name, eliminate_precursor($t);
	}
    }
    else {
	push @name, eliminate_precursor($de);
    }
    return grep{$_}
    grep { !/^(?:EC (?:(?:\d+|-)\.){3}(?:\d+|-)|Fragments?|Putative replicase)$/o }
    @name;
}

sub ext_DEGN{ ext_DE($_[0]), ext_GN($_[0]) }


=head1 NAME

Bio::ExtractNE::MakeDict - Package for creating dictionary

=head1 FUNCTIONS

=head2 mkdict($input_file, $output_dictfile)

This function creates named-entity dictionary.  Note that $input_file
is a hash. Currently, only SwissProt data is supported.

    mkdict({ sprot_file => "sprot", } => "sprot.dict");

=cut

sub get_synroot {
    my ($term, $sn_db) = @_;
    my @syn_root;
    foreach my $t (@$term){
	my $syn_root = $t;
	while(1){
	    last if $syn_root eq $sn_db->{$syn_root};
	    last if not exists $sn_db->{$syn_root};
	    $syn_root = $sn_db->{$syn_root};
	}
	push @syn_root, $syn_root if $syn_root;
    }
    List::Util::reduce { length($a) < length($b) ? $a : $b } @syn_root;
}

$|++;
sub mkdict {
    my $file = shift or die "Please specify input files";
    my $dictfile = shift or die "Please specify output dictionary file";

    my $tie_failure = sub { die "Cannot tie to $_[0] ($!)" };

    unlink $dictfile;
    tie my %dict,'DB_File', $dictfile, O_CREAT | O_RDWR, 0644, $DB_BTREE
	or tie_failure->($dictfile);
    my @subdbs = qw(lc hw ml sn sl);
    my %subdb;
    {
	no strict 'refs';
	foreach my $type (@subdbs){
	    unlink ${"${dictfile}.$type"};
	    tie %{$subdb{$type}}, 'DB_File', "${dictfile}.$type",
	    O_CREAT | O_RDWR, 0644, $DB_BTREE
		or tie_failure->(${"${dictfile}.$type"});
	}
    }

    my (%sl, %sn);

    my $cnt = 0;
    if(-e $file->{sprot_file}){
	open my $f, '<', $file->{sprot_file} or die $!;
	my $sprot;
	while(my $line = <$f>){
	    # Save string starting with
	    #  DE (description)
	    #  GN (gene name)
	    #  // (end of protein record)
	    $sprot .= $line if $line =~ m,^(?:DE|GN|//)\s,o;
	    if($line =~ m,^//,o){
		my @name =
		    sort {length$a<=>length$b} grep{length($_)>=3}
		grep {!$stopword{$_}}
		ext_DEGN($sprot);

		my $synroot = get_synroot(\@name, \%sn); # root of synonyms
		for my $item ( @name ){
		    
		    # skip it if name contains ()[] and
		    # has no balanced elements
#		    next if $item =~ /[()\[\]]/o &&$item !~ /$RE{balanced}{-parens=>'()[]'}/o;
		    
		    # otherwise
		    $dict{$item} = undef;
		    $sn{$item} = $synroot;
		}
		undef $sprot;

		# the line below is for testing and debugging.
		print $cnt."\r";
		++$cnt;
#		last if ++$cnt == 10000;
	    }

	}

	# Build lowercase dictionary
	while(my($k, undef) = each %dict){
	    $subdb{lc}->{lc $k} = $k;
	    my @tok = split / /o => $k;
	    $tok[0] = lc $tok[0];
	    $subdb{hw}->{$tok[0]} = 1;
	    if(scalar @tok > $subdb{ml}->{$tok[0]}){
		$subdb{ml}->{$tok[0]} = scalar @tok;
	    }
	}

#	use Data::Dumper;
#	print Dumper \%sn;
	# Build inverted list of synonyms
	while(my($k, $v) = each %sn){
	    next if $k eq $v;
	    $sl{$v}->{$k} = undef;
	}
	%{$subdb{sn}} = %sn;
	%sn = ();
	
	while(my($k, undef) = each %sl){
	    $subdb{sl}->{$k} = join"\x0", sort {length($a)<=>length($b)} keys%{$sl{$k}};
	}
    }

#    use Data::Dumper;
#    print Dumper \%sl;
#    print $/;
}



=head2 mkcwdict($input_file, $output_dictfile, $prebuilt_dictfile)

This function creates the common word dictionary.

  mkcwdict("/usr/share/dict/words" => "common_words.dict", "dict/sprot.dict");

  mkcwdict(
	   [ "/usr/share/dict/words", "med.txt",],
           "common_words.dict",  # output common word dictionary
	   "dict/sprot.dict"     # pre-built dictionary file
	   );

The first argument can be a scalar or an arrayref.

Please note that this function can only be used if you have your
dictionary built.

=cut

use Bio::ExtractNE::Dict;
sub mkcwdict {
    my @file = ref($_[0]) ? @{shift()} : (shift);
    my $cw_file = shift or die "Please specify output common word dictionary";
    my $dictfile = shift or die "Please specify protein dictionary for reference";

    unlink $cw_file;
    tie my %cw,  'DB_File', $cw_file, O_CREAT | O_WRONLY, 0644, $DB_BTREE
	or die "Cannot tie to $cw_file";

    my $dict = dict($dictfile);

    foreach my $file (@file){
	print STDERR "Reading from $file .....\n";
	if(!-r $file){
	    print STDERR "The file $file is readable and it's skipped.\n";
	    next;
	}
	open my $f, '<', $file;
	while(my $entry = <$f>){
	    chomp $entry;
	    if(!$dict->query($entry, 'lc')){
		$cw{$entry} = undef;
	    }
	    else {
		print "$entry is already a term in dictionary\n";
	    }
	}
    }

    untie %cw;
}


1;
__END__

=head1 NOTE

The two functions are both destructive. Previously built dictionary
will be erased before building a new one.

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2004 by Yung-chung Lin (a.k.a. xern) <xern@cpan.org>

This package is free software; you can redistribute it and/or modify
it under the same terms as Perl itself

=cut
