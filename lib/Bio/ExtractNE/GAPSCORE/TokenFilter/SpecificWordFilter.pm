package Bio::ExtractNE::GAPSCORE::TokenFilter::SpecificWordFilter ;


use strict ;
use Exporter::Lite ;
use Regexp::List ;

our @EXPORT = qw (filterSpecificWord) ;

my @roman_numerals ;
open R, "gapscore_data/roman_numerals" ;
while (<R>)
{
    chomp ;
    push @roman_numerals, $_ ;
}
close R ;

my @greek_letters ;
open G, "gapscore_data/greek_letters" ;
while (<G>)
{
    chomp ;
    push @greek_letters, $_ ;
}
close G ;

my @amino_acids ;
open A, "gapscore_data/amino_acids" ;
while (<A>)
{
    chomp ;
    push @amino_acids, $_ ;
}
close A ;

my @species ;
open S, "gapscore_data/species" ;
while (<S>)
{
    chomp ;
    push @species, $_ ;
    #print $_."\n" ;
}
close S ;

my @compounds ;
open C, "gapscore_data/compounds" ;
while (<C>)
{
    chomp ;
    push @compounds, $_ ;
}
close C ;

my $l  = Regexp::List->new ;

my $filter_pattern_regular_expression = $l->list2re (@roman_numerals, @greek_letters, @amino_acids, @species, @compounds) ;

sub filterSpecificWord
{
    my $tokens_ref = shift ;
    my @filtered_tokens = grep {!/^((\d+\.?\d*)|$filter_pattern_regular_expression)$/i} @$tokens_ref ;
    my @not_pass_specific = grep {/^((\d+\.?\d*)|$filter_pattern_regular_expression)$/i} @$tokens_ref ;
#    open F, "> not_pass_specific" ;
#    for (@not_pass_specific)
#    {
#        print F "$_\n" ;
#    }
#    close F ;
    \@filtered_tokens ;
}

1 ;
