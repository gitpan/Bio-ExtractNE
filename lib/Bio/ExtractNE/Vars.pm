package Bio::ExtractNE::Vars;

use strict;

use Exporter::Lite;
our @EXPORT = qw(
		 $DICT_PATH
		 %counterpart
		 $amino_pattern
		 $affix_pattern
		 $stoplist_pattern
		 $abbrev_pattern
		 $abst_pattern
		 $mkdict_pattern
		 $event_pattern
		 $event_verb_pattern
		 $event_ing_pattern
		 $event_ed_pattern
		 $event_nominal_pattern
		 );

our $DICT_PATH = "/etc/Bio-ExtractNE";


use Regexp::List;
my $l  = Regexp::List->new;

our %counterpart = qw'( ) ) ( [ ] ] [';

our $amino_regexp =
    $l->list2re(
		qw(
		   alanine arginine asparagine aspartic cysteine
		   glutamine glutamic glycine histidine isoleucine
		   leucine lysine methionine phenylalanine proline serine
		  threonine tryptophan tyrosine valine
		   )
		);

our $affix_pattern =
    $l->list2re(
		qw(

		   a ab ad aero alveus arthron atrium auto
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
		   zygon
		   )
		);

our $stoplist_pattern = $l->list2re(
				    qw(
				       protein proteins peptide chain
				       motif complex ATP cAMP
				       )
				    );


# the basic assumption about abbreviations is that they are initialed with
# capital letter and are followed by a alphanumeric letters.
# and there is no space in abbrev words
our $abbrev_pattern = qr'^[A-Z][A-Za-z0-9]+$';

# NOTE: the embedding tags are reserved for the use of Regexp::Bind
our $abst_pattern = qr'
<br>
 <font\ssize="\+1"><b>(?#<title>.+?)</b></font><br><br>
 <b>(?#<author>.+?)</b><br><br>
 (?#<organization>.+?)<br><br>
 (?#<text>.+?)<br><br>PMID:
'mx;

our $mkdict_pattern = qr'
#(?:ID\s{3}(?:.+?)\n.*?)
(?:DE\s{3}(.+?\.)\n.*?)
(?:GN\s{3}(.+?\.)\n.*?)?
//\n
'sox;



our @stem = qw(
 accumulat activat attenuat elevat hasten incite
  increas induc initiat promot stimulat transactivat up-regulat
  associat add bind catalyz complex control controll cleav demethylat
  dephosphorylat sever influenc contain methylat phosphorylat express
  overexpress produc block decreas deplet down-regulat downregulat
  impair inactivat inhibit reduc repress supress modifi apotosis
  myogenesis interact react disassembl discharg mediat modulat
  participat regulat replac substitut enhanc
 
 Accumulat Activat Attenuat Elevat Hasten Incite
  Increas Induc Initiat Promot Stimulat Transactivat Up-Regulat
  Associat Add Bind Catalyz Complex Control Controll Cleav Demethylat
  Dephosphorylat Sever Influenc Contain Methylat Phosphorylat Express
  Overexpress Produc Block Decreas Deplet Down-Regulat Downregulat
  Impair Inactivat Inhibit Reduc Repress Supress Modifi Apotosis
  Myogenesis Interact React Disassembl Discharg Mediat Modulat
  Participat Regulat Replac Substitut Enhanc
 
);

our $event_verb_pattern    = $l->list2re( map{ $_.'s', $_.'e', $_.'es', $_.'ed' } @stem );
our $event_ing_pattern     = $l->list2re( map{$_.'ing'} @stem );
our $event_ed_pattern      = $l->list2re( map{$_.'ed'} @stem );
our $event_nominal_pattern = $l->list2re( map{$_.'ion', $_.'tion'} @stem );

our $event_pattern =
  $l->list2re(
	      map{
		$_.'e',
		$_.'es',
		$_.'ed',
		$_.'ing',
		$_.'ion',
              } @stem
             );






1;
__END__
