package Bio::ExtractNE::GAPSCORE ;


use strict ;
use Exporter::Lite ;
use Bio::ExtractNE::GAPSCORE::TokenStreamBuilder ;
use Bio::ExtractNE::GAPSCORE::TokenFilter ;
use Bio::ExtractNE::GAPSCORE::Scorer ;
use Bio::ExtractNE::GAPSCORE::FullNameExtender ;
use Bio::ExtractNE::GAPSCORE::AbbreviationMatcher::AbbreviationCandidateFinder ;
use Bio::ExtractNE::GAPSCORE::AbbreviationMatcher::AbbreviationAligner ;


our @EXPORT = qw (getNames gapscore) ;

sub getNames
{
    my $text_ref = shift ;
#     my $sentences_ref = shift ;
#    print "$$text_ref\n" ;
    my $threshold = shift ;
#    print "$threshold\n" ;
#    my $tokens_ref = getTokens ($text_ref) ;

#    for (@$tokens_ref)
#    {
#        print "$_\n" ;
#    }

    my $sentences_ref = getSentences ($text_ref) ;

#    my $filtered_tokens = filterTokens ($tokens_ref) ;
#    my $sentences_ref = shift ;
#    my $threshold = shift ;

    my $filtered_tokens = filterTokens ($sentences_ref) ; 
#    for (@$filtered_tokens)
#    {
#        print "$_\n" ;
#    }

    my $token_and_score_ref = getScore ($filtered_tokens) ;
#    print "here\n" ;
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


sub gapscore
{
    my $self = shift ;
#    my $sentence_ref = \@_ ;
    my %gapname ;

    foreach my $s (@{$self->{sentence_ref}})
    {
#        print "$s\n" ;
        @gapname {@{getNames(\$s, 0.2)}} = ();
    }
    [ keys %gapname ];
}

1;

__END__


# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Bio::ExtractNE::GAPSCORE - Self-implemented GAPSCORE

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 SEE ALSO

L<Bio::ExtractNE>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2004 by Chin-Lin Peng. This package is free software;
you can redistribute it and/ or modify it under the same terms as Perl
itself

=cut

