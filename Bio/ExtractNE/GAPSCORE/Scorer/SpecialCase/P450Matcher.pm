package Bio::ExtractNE::GAPSCORE::Scorer::SpecialCase::P450Matcher ;


use strict ;
use Exporter::Lite ;
use Regexp::List ;


our @EXPORT = qw (isP450Family) ;

sub isP450Family
{
    my $token_ref = shift ;
    if ($$token_ref =~ /^(cytochrome|p450|\d+[a-zA-Z]\d+|(i|ii|iii|iv|v|vi|vii|viii|ix|x)[a-zA-Z]\d+|cyp\d+[a-zA-Z]\d+|(cyps?))$/i)
    {
        1 ;
    }
    else
    {
        0 ;
    }
}

1 ;
