package Bio::ExtractNE::GAPSCORE::Scorer::GeneralCase::Classifier ;


use strict ;
use Exporter::Lite ;
use AI::NaiveBayes1 ;
use Bio::ExtractNE::GAPSCORE::Scorer::GeneralCase::Appearance ;
use Bio::ExtractNE::GAPSCORE::Scorer::GeneralCase::Appearance::GeneName ;


our @EXPORT = qw (trainNameModel trainGeneNameModel) ;


sub trainGeneNameModel
{
    my $nb = AI::NaiveBayes1-> new ;
    $nb->set_real ('word_length') ;
    my $gene_name_data_file = shift ;

    open F, "$gene_name_data_file" ;
    while (<F>)
    {
        if ($_ =~ /^#.*/)
        {
            next ;
        }
        chomp $_ ;
        my @name_and_answer = split /@/, $_ ;
        my $name_vector_ref = getGeneNameFeatureVectorForTraining (\$name_and_answer[0]) ;
        $nb->add_instance (attributes=>{word_length=>shift @$name_vector_ref}, label=>'isGeneName='.($name_and_answer[1])) ;
    }
    close F ;

    $nb->train ;
    $nb->export_to_YAML_file ('gapscore_data/GeneNameModel') ;
}

sub trainNameModel
{
    my $nb = AI::NaiveBayes1-> new ;
    $nb->set_real ('gene_name') ;

    my $nb_gene_name = AI::NaiveBayes1->import_from_YAML_file ('gapscore_data/GeneNameModel') ;

    my $gene_symbol_data_file = shift ;
    my $gene_name_data_file = shift ;

    open F, "$gene_symbol_data_file" ;
    while (<F>)
    {
        if ($_ =~ /^#.*/)
        {
            next ;
        }
        chomp $_ ;
        my @symbol_and_answer = split /@/, $_ ;
        my $symbol_vector_ref = getAppearanceFeatureVector (\$symbol_and_answer[0], \$nb_gene_name) ;
        $nb->add_instance (attributes=>{A1=>shift @$symbol_vector_ref, A2=>shift @$symbol_vector_ref, A3=>shift @$symbol_vector_ref, A4=>shift @$symbol_vector_ref, A5=>shift @$symbol_vector_ref, A6=>shift @$symbol_vector_ref, A7=>shift @$symbol_vector_ref,A8=>shift @$symbol_vector_ref, A9=>shift @$symbol_vector_ref, A10=>shift @$symbol_vector_ref, A11=>shift @$symbol_vector_ref, A12=>shift @$symbol_vector_ref, A13=>shift @$symbol_vector_ref, gene_name=>shift @$symbol_vector_ref}, label=>'isName='.($symbol_and_answer[1])) ;
    }
    close F ;

    open F, "$gene_name_data_file" ;
    while (<F>)
    {
        if ($_ =~ /^#.*/)
        {
            next ;
        }
        chomp $_ ;
        my @name_and_answer = split /@/, $_ ;
        my $symbol_vector_ref = getAppearanceFeatureVector (\$name_and_answer[0], \$nb_gene_name) ;
        $nb->add_instance (attributes=>{A1=>shift @$symbol_vector_ref, A2=>shift @$symbol_vector_ref, A3=>shift @$symbol_vector_ref, A4=>shift @$symbol_vector_ref, A5=>shift @$symbol_vector_ref, A6=>shift @$symbol_vector_ref, A7=>shift @$symbol_vector_ref,A8=>shift @$symbol_vector_ref, A9=>shift @$symbol_vector_ref, A10=>shift @$symbol_vector_ref, A11=>shift @$symbol_vector_ref, A12=>shift @$symbol_vector_ref, A13=>shift @$symbol_vector_ref, gene_name=>shift @$symbol_vector_ref}, label=>'isName='.($name_and_answer[1])) ; 
    }
    close F ;

    $nb->train ;
    $nb->export_to_YAML_file ('gapscore_data/NameModel') ;
}

1 ;
