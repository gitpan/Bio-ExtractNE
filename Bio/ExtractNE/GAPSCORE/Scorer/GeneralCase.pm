package Bio::ExtractNE::GAPSCORE::Scorer::GeneralCase ;


use strict ;
use AI::NaiveBayes1 ;
use Exporter::Lite ;
use Bio::ExtractNE::GAPSCORE::Scorer::GeneralCase::Appearance ;


our @EXPORT = qw (getGeneralCaseScore) ;

sub getGeneralCaseScore
{
    my $nb = AI::NaiveBayes1->import_from_YAML_file ('gapscore_data/GeneNameModel') ;

    my $tokens_ref = shift ;
    my $nb_ref = shift ;
    my %valued_tokens ;
    for (@$tokens_ref)
    {
        my $appearance_feature_vector_ref = getAppearanceFeatureVector (\$_, \$nb) ;
        my $p = $$nb_ref->predict (attributes=>{A1=>(shift @$appearance_feature_vector_ref), A2=>(shift @$appearance_feature_vector_ref), A3=>(shift @$appearance_feature_vector_ref), A4=>(shift @$appearance_feature_vector_ref), A5=>(shift @$appearance_feature_vector_ref), A6=>(shift @$appearance_feature_vector_ref), A7=>(shift @$appearance_feature_vector_ref), A8=>(shift @$appearance_feature_vector_ref), A9=>(shift @$appearance_feature_vector_ref), A10=>(shift @$appearance_feature_vector_ref), A11=>(shift @$appearance_feature_vector_ref), A12=>(shift @$appearance_feature_vector_ref), A13=>(shift @$appearance_feature_vector_ref), gene_name=>shift @$appearance_feature_vector_ref}) ;
        $valued_tokens{$_} = $p->{'isName=yes'} ;
    }
    \%valued_tokens ;
}

1 ;
