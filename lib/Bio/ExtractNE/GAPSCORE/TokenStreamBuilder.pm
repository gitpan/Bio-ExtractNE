package Bio::ExtractNE::GAPSCORE::TokenStreamBuilder ;


use strict ;
use Exporter::Lite ;
use Bio::ExtractNE::GAPSCORE::TokenStreamBuilder::SentenceSpliter ;
use Bio::ExtractNE::GAPSCORE::TokenStreamBuilder::Tokenizer ;


our @EXPORT = qw (getTokens getSentences) ;

sub getSentences
{
    my $text_ref = shift ;
    my $sentence_set_ref = &splitSentence ($text_ref) ;
    $sentence_set_ref ;
}

sub getTokens
{
    my $text_ref = shift ;
    my @tokens ;
    my $sentence_set_ref = &splitSentence ($text_ref) ;

    open F, "> test_sentences" ;
    for (@$sentence_set_ref)
    {
        print F "$_\n" ;
    }
    close F ;

    my $tokens_ref = tokenize ($sentence_set_ref) ;
    
    open F, "> test_tokens" ;
    for (@$tokens_ref)
    {
        print F "$_\n" ;
    }
    close F ;

    $tokens_ref ;
}

1 ; 
