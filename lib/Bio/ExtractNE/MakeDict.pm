package Bio::ExtractNE::MakeDict;

=head1 NAME

Bio::ExtractNE::MakeDict - Class for creating dictionary

=head1 FUNCTIONS

=cut

use strict;

use Exporter::Lite;
our @EXPORT = qw(
		 mkdict
		 mkcwdict
		 );

use Regexp::Bind qw(global_bind);
use Bio::ExtractNE::Vars;
use Regexp::Common qw/balanced/;
use Bio::ExtractNE::MakeDict::Util;

use YAML;
use DB_File;
use Bio::ExtractNE::Stoplist;


=head2 mkdict($input_file, $output_dictfile)

This function creates named-entity dictionary.  Note that $input_file
is a hash. Currently, only SwissProt data is supported.


    mkdict(
       {
           sprot_file => "sprot",
       },
       "sprot.dict"
       );

=cut

sub mkdict {
    my $file = shift or die;
    my $dictfile = shift or die;

    my $lc_dictfile = "$dictfile.lc";  # lowercase
    my ( %dict, %lc_dict);
    if($dictfile){
	unlink $dictfile;
	tie %dict,  'DB_File', $dictfile, O_CREAT | O_WRONLY, 0644, $DB_BTREE;
	tie %lc_dict,  'DB_File', $lc_dictfile, O_CREAT | O_WRONLY, 0644, $DB_BTREE;
    }

    my $cnt = 0;
    if(-e $file->{sprot_file}){
	open my $f, '<', $file->{sprot_file} or die $!;
	my $sprot;
	
	while($_ = <$f>){
	    $sprot .= $_ if m,^(?:DE|GN|//)\s,;
	    if(m,^//,){
		my $protodict = global_bind($sprot, $mkdict_pattern, qw(DE GN));
		_ppdict($protodict);
		if($dictfile){
		    for my $item ( @{_flatten($protodict)} ){
			
			next if length $item < 3;
			next if $stopword{$item};
			next if $item !~ /\w/o;
			
			# skip it if name contains ()[] and
			# has no balanced elements
			next if $item =~ /[()\[\]]/o &&
			    $item !~ /$RE{balanced}{-parens=>'()[]'}/o;
			
			# otherwise
			$dict{$item} = 1;
			$lc_dict{lc $item} = $_;
		    }
		}
		else {
		    _flatten($protodict);
		}
		$sprot = '';
		print $cnt."\r";
		++$cnt;
#		last if ++$cnt == 50;
	    }
	}
    }


    untie %dict;
    untie %lc_dict;
    print $/;
}



=head2 mkcwdict($input_file, $output_dictfile)

This function creates the common word dictionary.
Note that $input_file is an array.

  mkcwdict(
	   [ "/usr/share/dict/words", "med.txt",],
           "common_words.db", "dict/sprot.dict"
	   );


=cut


use Bio::ExtractNE::Dict;
# make common words dictionary
sub mkcwdict {
    my @file = ref($_[0]) ? @{shift()} : (shift);
    my $cw_file = shift or die;
    my $dict_file = shift or die;
    my %cw;

    if($cw_file){
	unlink $cw_file;
	tie %cw,  'DB_File', $cw_file, O_CREAT | O_WRONLY, 0644, $DB_BTREE;
    }

    foreach my $file (@file){
	print STDERR "Transferring $file\n";
	open my $f, '<', $file;
	my $dict = dict($dict_file);
	while(my $e = <$f>){
	    chomp $e;
	    if(!$dict->query($e, 'lc')){
		$cw{$e} = undef;
	    }
	    else {
		print "$e\n";
	    }
	}
    }

    untie %cw;
}


1;
__END__

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2004 by Yung-chung Lin (a.k.a. xern) <xern@cpan.org>

This package is free software; you can redistribute it and/or modify
it under the same terms as Perl itself
