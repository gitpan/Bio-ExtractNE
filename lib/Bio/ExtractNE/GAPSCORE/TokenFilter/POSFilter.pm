package Bio::ExtractNE::GAPSCORE::TokenFilter::POSFilter ;


use strict ;
use Exporter::Lite ;
use Lingua::EN::Tagger ;

our @EXPORT = qw (filterPOS) ;

sub filterPOS 
{
#    my $tokens_ref = shift ;
    my $sentences_ref = shift ;

    my $tagger = Lingua::EN::Tagger->new ;

    my @tagged_tokens ;

#    open F, "> not_pass_POS" ;
#    for (@$tokens_ref)
#    {
#        my $tagged_token = $tagger->add_tags ($_) ;
#        if ($tagged_token =~ /^<(cd|fw|jj.?|nn.*|prp.?|vbg|vbn|wp.?)>(.+)<\/\1>$/i)
#        {
#            push @tagged_tokens, $2 ;
#        }
#        else
#        {
#            print F "$2\n" ;
#        }
#    }

    for (@$sentences_ref)
    {
        my $tagged_sentence = $tagger->add_tags ($_) ;
#        print "$tagged_sentence\n" ;
        my @temp = split / /, $tagged_sentence ;

        for (@temp)
        {
            if ($_ =~ /^<(cd|fw|jj.?|nn.*|prp.?|vbg|vbn|wp.?)>(.+)<\/\1>$/i)
            {
                push @tagged_tokens, $2 ;
            }
 #           else
 #           {
 #               print F "$2\n" ;
 #           }
        }
    }

#    close F ;
    \@tagged_tokens ;
}

1 ;
