package Bio::ExtractNE::GAPSCORE::TokenFilter::PatternFilter ;


use strict ;
use Exporter::Lite ;
use Regexp::List ;

our @EXPORT = qw (filterPattern) ;

my $l = Regexp::List->new ;

my $match_regular_expression = $l->list2re (qw (protein DNA gene)) ;
my $part_regular_expression = $l->list2re (qw (peptide chain motif complex)) ;
my $molecule_regular_expression = $l->list2re (qw (ATP cAMP)) ;
my $type_regular_expression = $l->list2re (qw (receptor expressed)) ;

sub filterPattern
{
    my $tokens_ref = shift ;
    my @filtered_tokens = grep !/^($match_regular_expression|$part_regular_expression|$molecule_regular_expression|$type_regular_expression)$/i, @$tokens_ref ;
    my @not_pass_pattern = grep /^($match_regular_expression|$part_regular_expression|$molecule_regular_expression|$type_regular_expression)$/i, @$tokens_ref ;
   
#    open F, "> not_pass_pattern" ;
#    for (@not_pass_pattern)
#    {
#        print F "$_\n" ;
#    }
#    close F ;

    \@filtered_tokens ;
}

1 ;

