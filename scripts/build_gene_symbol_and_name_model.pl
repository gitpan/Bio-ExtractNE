#!/usr/bin/perl -IBio


use Bio::ExtractNE::GAPSCORE::Scorer::GeneralCase::Classifier ;


trainGeneNameModel ('gapscore_data/GeneNameTrainingData') ;
trainNameModel ('gapscore_data/GeneSymbolTrainingData', 'gapscore_data/GeneNameTrainingData') ;
