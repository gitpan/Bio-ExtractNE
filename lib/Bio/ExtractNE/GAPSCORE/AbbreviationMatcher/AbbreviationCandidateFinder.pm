package Bio::ExtractNE::GAPSCORE::AbbreviationMatcher::AbbreviationCandidateFinder ;


use strict ;
use Exporter::Lite ;
use Lingua::EN::Tagger ;
use Regexp::List ;

our @EXPORT = qw (findAbbreviationCandidate) ;

sub findAbbreviationCandidate
{
    my $full_names_ref = shift ;
    my $sentences_ref = shift ;

    my %abbreviation ;
    for my $sentence (@$sentences_ref)
    {
        if ($sentence =~ /\(|\)/i)
        {
            for my $full_name (keys %$full_names_ref)
            {
                while ($sentence =~ /.*$full_name\s?\((.+)\).*/gi)
                {
                    $abbreviation{$full_name} = $1 ;
                }

                while ($sentence =~ /(.*)\s?\(\s?$full_name\s?\).*/gi)
                {
                    $abbreviation{$1} = $full_name ;
                }
            }
        }
    }

    \%abbreviation ;
}

1 ;
