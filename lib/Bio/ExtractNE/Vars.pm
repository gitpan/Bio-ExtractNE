package Bio::ExtractNE::Vars;

use strict;

use Regexp::List;
use Exporter::Lite;
our @EXPORT = qw(
		 %counterpart
		 $amino_pattern
		 $affix_pattern
		 $stoplist_pattern

		 $first_default_dictfile
		 $second_default_dictfile
		 );


my $l  = Regexp::List->new;

our %counterpart = qw'( ) ) ( [ ] ] [';

our $amino_regexp =
    $l->list2re(qw(alanine arginine asparagine aspartic cysteine
		   glutamine glutamic glycine histidine isoleucine
		   leucine lysine methionine phenylalanine proline serine
		   threonine tryptophan tyrosine valine));


our $affix_pattern =
    $l->list2re(qw(a ab ad aero alveus arthron atrium auto
		   bacterio bi bio carnis carn chele chloro
		   chroma con cytis cyto dermis derm di ecto
		   endo epi eu exo feto gastro geo gymno halo
		   hemato hemi herb hetero histo homo hydro
		   hyper hypo inter intra iso karyo leuco locus
		   lysis macro maxilla mensis mesos meta micro
		   mono morph multi mut myco neco neur nomen
		   niga oculo oligo omni osteo paleo peri
		   pestis phaeo phage photo phyto pino plankto
		   poly pseudo primordis pro renes reptilis
		   rhiza rhizo sapros soma sonus sperma spirare
		   taxis telo thallus therm thrombos trans tri
		   tricho troph uni vasculum vor xero zoo zoa
		   zygon));

our $stoplist_pattern =
    $l->list2re(qw(protein proteins peptide chain motif complex ATP cAMP));



my $default_dictpath = '/usr/local/Bio-ExtractNE';

our $first_default_dictfile
    = ($ENV{BENEDICTPATH} || $default_dictpath) . '/sprot.dict';

our $second_default_dictfile = 'dict/sprot.dict';

our $default_commonwords_file =
    ($ENV{BENEDICTPATH} || $default_dictpath) . '/common_words.dict'; 

1;
__END__
