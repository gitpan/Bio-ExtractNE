use strict;
BEGIN{unshift @INC, './lib'}

use File::Copy;
use File::Path;
use ExtUtils::MakeMaker;

sub change_default_dictpath {
    my $path = shift;
    open my $f, 'lib/Bio/ExtractNE/Vars.pm' or die $!;
    local $/;
    my $t = <$f>;
    $t =~ s(default_dictpath = '.+?')(default_dictpath = '$path');
    close $f;
    open my $f, '>', 'lib/Bio/ExtractNE/Vars.pm' or die $!;
    print $f $t;
}
sub install_dict {
    my $dict_dir = '/usr/local/Bio-ExtractNE';

    my $input = prompt("\nThe dictionary will be installed into?", 
		    '/usr/local/Bio-ExtractNE');
    $dict_dir = $input if $input;

    mkpath([$dict_dir], 0, 0755);
    change_default_dictpath($dict_dir);

    for my $file (glob("dict/sprot*"), "dict/common_words.dict"){
	my $dest_file = ($file =~ m,dict/, => $'); 
        print "Copying $file to $dict_dir/$dest_file ... ";
	copy("$file", "$dict_dir/$dest_file") or die $!;
        print "Done$/";
    }
}

sub build_dict {
    use Bio::ExtractNE::MakeDict;
    mkdict( { sprot_file => "data/dict.src" } => "sprot.dict" );
    move($_ => "dict/$_") for glob("sprot.dict*");
}

if($ARGV[0] ne 'clean'){
    build_dict() if prompt("Build the dictionary?", 'y') !~ /n/i;
    install_dict() if prompt("Install the dictionary?", 'y') !~ /n/i;
}

WriteMakefile
    (
     'NAME'             => 'Bio::ExtractNE',
     'VERSION_FROM'     => 'lib/Bio/ExtractNE.pm',
     'dist'             => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
     'PREREQ_PM'                => {
	 qw(
	    AI::NaiveBayes1         1.10
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
     'EXE_FILES'       => [ 'bin/bene.pl' ],
     ($] >= 5.005 ?
      (ABSTRACT_FROM => 'lib/Bio/ExtractNE.pm',
       AUTHOR     => 'Yung-chung Lin <xern@cpan.org>') : ()),

     );

