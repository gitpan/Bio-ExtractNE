package Bio::ExtractNE::GAPSCORE::Scorer::SpecialCase ;


use strict ;
use Exporter::Lite ;
use Bio::ExtractNE::GAPSCORE::Scorer::SpecialCase::EnzymeMatcher ;
use Bio::ExtractNE::GAPSCORE::Scorer::SpecialCase::P450Matcher ;


our @EXPORT = qw (isSpecialCase) ;

sub isSpecialCase
{
    my $token_ref = shift ;
    if (isEnzyme ($token_ref))
    {
        1 ;
    }
    elsif (isP450Family ($token_ref))
    {
        1 ;
    }
    else
    {
        0 ;
    }
}

1 ;
