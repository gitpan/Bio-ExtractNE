use strict;

use File::Copy;
use File::Path;
use ExtUtils::MakeMaker;

sub install_dict {
    my $dict_dir = '/usr/local/Bio-ExtractNE';
    my $input = prompt("\nThe dictionary will be installed into?", 
		    '/usr/local/Bio-ExtractNE');
    $dict_dir = $input if $input;
    mkpath([$dict_dir], 0, 0755);
    for my $file (glob("dict/sprot*"), "dict/common_words.db"){
	my $dest_file = ($file =~ m,dict/, => $'); 
        print "Copying $file to $dict_dir/$dest_file ... ";
	copy("$file", "$dict_dir/$dest_file") or die $!;
        print "Done$/";
    }
}

install_dict() if prompt("Install the dictionary?", 'y') !~ /n/i;


WriteMakefile
    (
     'NAME'             => 'Bio::ExtractNE',
     'VERSION_FROM'     => 'lib/Bio/ExtractNE.pm',
     'PREREQ_PM'                => {
	 qw(
	    AI::NaiveBayes1         1.10
            Compress::Zlib          1.33
            Exporter::Lite          0.01
            File::Which             0.05
            HTML::Entities          1.27
            IO::Zlib                1.04
            Lingua::EN::Inflect     1.88
            Lingua::EN::Tagger      0
            LWP::Simple             1.38
            Quantum::Superpositions 1.05
            Regexp::Bind            0.04
            Regexp::List            0.12
            Regexp::Common          2.112
            RPC::XML::Client        0
            Test::More              0
            YAML                    0.35
	    )
	 },
     ($] >= 5.005 ?
      (ABSTRACT_FROM => 'lib/Bio/ExtractNE.pm',
       AUTHOR     => 'Yung-chung Lin <xern@cpan.org>') : ())
     );

