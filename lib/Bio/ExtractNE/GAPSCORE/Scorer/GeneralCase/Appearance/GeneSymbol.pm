package Bio::ExtractNE::GAPSCORE::Scorer::GeneralCase::Appearance::GeneSymbol ;


use strict ;
use Exporter::Lite ;

our @EXPORT = qw (getGeneSymbolFeatureVector) ;

sub getGeneSymbolFeatureVector
{
    my @vector ;
    my $token_ref = shift ;

    if ((length $$token_ref) == 1)
    {
        push @vector, qw/1 0 0 0/ ;
    }
    elsif ((length $$token_ref) == 2)
    {
        push @vector, qw/0 1 0 0/ ;
    }
    elsif ((length $$token_ref >= 3) && (length $token_ref <=5))
    {
        push @vector, qw/0 0 1 0/ ;
    }
    else
    {
        push @vector, qw/0 0 0 1/ ;
    }

    if ($$token_ref =~ /^\d/)
    {
        push @vector, 1 ;
    }
    else
    {
        push @vector, 0 ;
    }
   
    if ($$token_ref =~ /\d$/)
    {
        push @vector, 1 ;
    }
    else
    {
        push @vector, 0 ;
    }

    if ($$token_ref =~ /(I|II|III|IV|V|VI|VII|VIII|IX|X)$/)
    {
        push @vector, 1 ;
    }
    else
    {
        push @vector, 0 ;
    }
    
    if ($$token_ref eq "\U$$token_ref")
    {
        push @vector, 1 ;
    } 
    else
    {
        push @vector, 0 ;
    }

    if ($$token_ref =~ /[A-Z]$/)
    {
        push @vector, 1 ;
    }
    else
    {
        push @vector, 0 ;
    }

    unless ($$token_ref eq "\U$$token_ref")
    {
        unless ($$token_ref eq "\L$$token_ref")
        {
            push @vector, 1 ;
        }
        else
        {
            push @vector, 0 ;
        }
    }
    else
    {
        push @vector, 0 ;
    }

    if ($$token_ref =~ /[A-Z]+\d+$/)
    {
        push @vector, 1 ;
    }
    else
    {
        push @vector, 0 ;
    }

    if ($$token_ref =~ /(I|II|III|IV|V|VI|VII|VIII|IX|X)/)
    {
        push @vector, 1 ;
    }
    else
    {
        push @vector, 0 ;
    }

    if ($$token_ref =~ /-/)
    {
        push @vector, 1 ;
    }
    else
    {
        push @vector, 0 ;
    }

    \@vector ;
}

1 ;
