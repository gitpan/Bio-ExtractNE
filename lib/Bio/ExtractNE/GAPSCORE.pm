package Bio::ExtractNE::GAPSCORE ;


use strict ;

# These following packages' naming is not done by XERN
# I would not ever use these lengthy thingy.

use Bio::ExtractNE::GAPSCORE::TokenStreamBuilder;
use Bio::ExtractNE::GAPSCORE::TokenFilter;
use Bio::ExtractNE::GAPSCORE::Scorer;
use Bio::ExtractNE::GAPSCORE::FullNameExtender;
use Bio::ExtractNE::GAPSCORE::AbbreviationMatcher::AbbreviationCandidateFinder;
use Bio::ExtractNE::GAPSCORE::AbbreviationMatcher::AbbreviationAligner;

sub getNames {
    my $text_ref = shift ;
    my $threshold = shift ;
    my $sentences_ref = getSentences ($text_ref) ;

    my $filtered_tokens = filterTokens ($sentences_ref) ; 

    my $token_and_score_ref = getScore ($filtered_tokens) ;
    my %valued_tokens ;

    while (my ($key, $value) = each %$token_and_score_ref)
    {
        if ($value >= $threshold) {
            $valued_tokens{$key} = $value ;
        }
    }
    
    my $full_names_ref = extendNames (\%valued_tokens, $sentences_ref) ;
    [keys %$full_names_ref] ;      
}


sub gapscore {
    my $self = shift ;
    my %gapname ;

    foreach my $s (@{$self->{sentence_ref}}) {
        @gapname {@{getNames(\$s, 0.2)}} = ();
    }
    [ keys %gapname ];
}

1;

__END__
