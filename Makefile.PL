use ExtUtils::MakeMaker;

use File::Copy;

sub install_dict {
    $dict_dir = '/usr/local/Bio-ExtractNE';
    print "\nThe dictionary will be installed into [/usr/local/Bio-ExtractNE]?  ";
    chomp($input = <STDIN>);
    $dict_dir = $input if $input;
    mkdir $dict_dir;
    for $file (glob("dict/sprot*"), "dict/common_words.db"){
	$dest_file = ($file =~ m,dict/,, $'); 
	copy("$file", "$dict_dir/$dest_file") or die $!;
    }
}

print "Install the dictionary, [Y/n]?";
unless (<STDIN> =~ /n/i){
    &install_dict();
}

#mkdir 'lib';
#`cp -rf Bio/ lib/`;
WriteMakefile
    (
     'NAME'             => 'Bio::ExtractNE',
     'VERSION_FROM'     => 'Bio/ExtractNE.pm',
     'PREREQ_PM'                => {
	 qw(
	    LWP::Simple             1.38
	    YAML                    0.35
	    HTML::Entities          1.27
	    Exporter::Lite          0.01
	    Lingua::EN::Inflect     1.88
	    Lingua::EN::Tagger      0
	    Regexp::Common          2.112
	    Regexp::Bind            0.04
	    Quantum::Superpositions 1.05
	    Test::More              0
	    RPC::XML::Client        0
	    )
	 },
     PMLIBDIRS => [ 'lib' ],
     ($] >= 5.005 ?
      (ABSTRACT_FROM => 'Bio/ExtractNE.pm',
       AUTHOR     => 'Yung-chung Lin <xern@cpan.org>') : ())
     );


