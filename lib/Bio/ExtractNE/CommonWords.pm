package Bio::ExtractNE::CommonWords;

use DB_File;
use Exporter::Lite;
use Lingua::EN::Inflect qw ( PL PL_N PL_V PL_ADJ NO NUM
			     PL_eq PL_N_eq PL_V_eq PL_ADJ_eq
			     A AN
			     PART_PRES
			     ORD NUMWORDS
			     inflect classical
			     def_noun def_verb def_adj def_a def_an );

our @EXPORT = qw(
		 %common_word
		 &load_commonwords
		 &common_word
		 );


my %common_word;

sub load_commonwords {
    my $cwdb = '/usr/local/Bio-ExtractNE/common_words.dict';
    tie %common_word, 'DB_File',
    (-e $cwdb ? $cwdb : 'dict/common_words.dict' ),
    O_RDONLY, 0644, $DB_BTREE or die $!;
}

sub common_word {
    my $word = shift;
    return 1 if exists $common_word{$word};
    return 1 if $word =~ /\w+ion$/o;
    0;
}


END {
    untie %common_word;
}

1;
