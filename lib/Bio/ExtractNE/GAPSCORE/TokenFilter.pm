package Bio::ExtractNE::GAPSCORE::TokenFilter ;


use strict ;
use Exporter::Lite;
use Bio::ExtractNE::GAPSCORE::TokenFilter::POSFilter ;
use Bio::ExtractNE::GAPSCORE::TokenFilter::SpecificWordFilter ;
use Bio::ExtractNE::GAPSCORE::TokenFilter::PatternFilter ;

our @EXPORT = qw (filterTokens) ;
 
sub filterTokens
{
#    my $tokens_ref = shift ;
#    my $tagged_tokens_ref = filterPOS ($tokens_ref) ;
    my $sentences_ref = shift ;
    my $tagged_tokens_ref = filterPOS ($sentences_ref) ;

#    open F, "> throughPOS" ;
#    for (@$tagged_tokens_ref)
#    {
#        print F "$_\n" ;
#    }
#    close F ;

    my $word_removed_tokens_ref = filterSpecificWord ($tagged_tokens_ref) ;

#    open F, "> throughSpecific" ;
#    for (@$word_removed_tokens_ref)
#    {
#        print F "$_\n" ;
#    }
#    close F ;

    my $pattern_removed_tokens_ref = &filterPattern ($word_removed_tokens_ref) ;

#    open F, "> throughPattern" ;
#    for (@$pattern_removed_tokens_ref)
#    {
#        print F "$_\n" ;
#    }
#    close F ;

    $pattern_removed_tokens_ref ;
}

1 ;
