package Bio::ExtractNE::GAPSCORE::Scorer::GeneralCase::Appearance::GeneName ;


use strict ;
use Exporter::Lite ;
use AI::NaiveBayes1 ;


our @EXPORT = qw (getGeneNameFeatureVectorForTraining getGeneNameFeatureVector) ;

sub getGeneNameFeatureVectorForTraining
{
    my $token_ref = shift ;
    my @vector ;

    push @vector, length $$token_ref ;
    \@vector ;
}

sub getGeneNameFeatureVector
{
    my $token_ref = shift ;
    my $nb_ref = shift ;
    my $p = $$nb_ref->predict (attributes=>{word_length=>length $$token_ref}) ;
    $p->{'isGeneName=yes'} ;
}

1 ;
