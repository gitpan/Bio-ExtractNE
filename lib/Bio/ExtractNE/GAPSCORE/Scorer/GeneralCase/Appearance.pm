package Bio::ExtractNE::GAPSCORE::Scorer::GeneralCase::Appearance ;


use strict ;
use Exporter::Lite ;
use Bio::ExtractNE::GAPSCORE::Scorer::GeneralCase::Appearance::GeneSymbol ;
use Bio::ExtractNE::GAPSCORE::Scorer::GeneralCase::Appearance::GeneName ;


our @EXPORT = qw (getAppearanceFeatureVector) ;

sub getAppearanceFeatureVector
{
    my $token_ref = shift ;
    my $nb_gene_name_model_ref = shift ;
    my @vector ;
    my $gene_symbol_feature_vector_ref = getGeneSymbolFeatureVector ($token_ref) ;

    push @vector, @$gene_symbol_feature_vector_ref ;
    if ($$token_ref =~ /in$/i)
    {
        push @vector, getGeneNameFeatureVector ($token_ref, $nb_gene_name_model_ref) ;
    }
    else
    {
        push @vector, 0 ;
    }
    \@vector ;
}

1 ;
