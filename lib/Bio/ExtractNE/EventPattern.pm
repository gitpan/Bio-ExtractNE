package Bio::ExtractNE::EventPattern;

use Regexp::List;
use Exporter::Lite;
our @EXPORT = qw(
                 $event_pattern
                 $event_verb_pattern
                 $event_ing_pattern
                 $event_ed_pattern
                 $event_nominal_pattern
                 );


my $l  = Regexp::List->new;


our @event_stem = map{$_ ,ucfirst $_}
 qw(accumulat activat attenuat elevat hasten incite
    increas induc initiat promot stimulat transactivat up-regulat
    associat add bind catalyz complex control controll cleav demethylat
    dephosphorylat sever influenc contain methylat phosphorylat express
    overexpress produc block decreas deplet down-regulat downregulat
    impair inactivat inhibit reduc repress supress modifi apotosis
    myogenesis interact react disassembl discharg mediat modulat
    participat regulat replac substitut enhanc);

our $event_verb_pattern    =
    $l->list2re( map{ $_.'es', $_.'ed', $_.'s', $_.'e', $_ } @event_stem );
our $event_ing_pattern     = $l->list2re( map{$_.'ing'} @event_stem );
our $event_ed_pattern      = $l->list2re( map{$_.'ed'} @event_stem );
our $event_nominal_pattern = $l->list2re( map{$_.'tion', $_.'ion'} @event_stem );

our $event_pattern =
    $l->list2re(map{
		     $_.'ion',
		     $_.'ing',
		     $_.'ed',
		     $_.'es',
		     $_.'e',
		     $_
		 } @event_stem
		);



1;
