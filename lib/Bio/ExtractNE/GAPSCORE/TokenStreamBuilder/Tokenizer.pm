package Bio::ExtractNE::GAPSCORE::TokenStreamBuilder::Tokenizer ;


use strict ;
use Exporter::Lite ;


our @EXPORT = qw (tokenize) ;

sub tokenize
{
    my $sentence_set_ref = shift ;
    my @tokens ;
    for (@$sentence_set_ref)
    {
        my @temp = split /[+!?,\t:;" ()<>{}\[\]%]/, $_ ;
        for (@temp)
        {
            unless ($_ =~ /^\s*$/)
            {
                if ($_ =~ /(^[A-Za-z0-9]-.+$)|(^.+-(\d+|I|II|III|IV|V|VI|VII|VIII|IX|X)$)/)
                {
                    push @tokens, $_ ;
                }
                else
                {
                    push @tokens, (split /-/, $_) ;
                }
            }
        }
    }
    \@tokens ;
}

1 ;


