package Bio::ExtractNE::GAPSCORE::TokenStreamBuilder::SentenceSpliter ;


use strict ;
use Exporter::Lite ;


our @EXPORT = qw (splitSentence) ;

sub splitSentence
{
    my $text_ref = shift ;
    my ($sentence, @sentence_set) ;
    while ($$text_ref =~ m,((.+?)(\.|\?|!|$))(?=(?: [A-Z]|$)),g)
    {
        ($sentence = $2) =~ s/^\s+(.+)/$1/o ;
        if ($sentence ne 'e.g')
        {
            push @sentence_set, $sentence ;
        }
    }
    \@sentence_set ;
}

1 ;

