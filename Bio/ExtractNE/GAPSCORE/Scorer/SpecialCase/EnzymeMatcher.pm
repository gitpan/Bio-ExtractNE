package Bio::ExtractNE::GAPSCORE::Scorer::SpecialCase::EnzymeMatcher ;


use strict ;
use Exporter::Lite ;
use Regexp::List ;


our @EXPORT = qw (isEnzyme);

my @not_enzyme_list ;
open F, "gapscore_data/NotEnzymeList" ;
while (<F>)
{
    chomp ;
    push @not_enzyme_list, $_ ;
}
close F ;

my $l  = Regexp::List->new ;
my $not_enzyme_list_regular_expression = $l->list2re (@not_enzyme_list) ;
 
sub isEnzyme
{

    my $token_ref = shift ;
    unless ($$token_ref =~ /ases?$/i)
    {
        0 ;
    }
    else
    {
        if ($$token_ref =~ /^$not_enzyme_list_regular_expression$/i)
        {
            0 ;
        }
        else
        {
            1 ;
        } 
    }
}

1 ;
