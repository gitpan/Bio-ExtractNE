package Bio::ExtractNE::GAPSCORE::Scorer ;


use strict ;
use Exporter::Lite ;
use AI::NaiveBayes1 ;
use Bio::ExtractNE::GAPSCORE::Scorer::GeneralCase ;
use Bio::ExtractNE::GAPSCORE::Scorer::SpecialCase ;
use YAML ;


our @EXPORT = qw (getScore);
 
sub getScore
{
    my $tokens_ref = shift ;
#    for (@$tokens_ref)
#    {
#        print "$_\n" ;
#    }
#    print "begin\n" ;
    my $classifier = AI::NaiveBayes1->import_from_YAML_file ('gapscore_data/NameModel') ;
#    print "pass\n" ;
    my %valued_tokens ;
    my @general_case ;
    for (@$tokens_ref)
    {
#        print "original : $_\n" ;
        if (isSpecialCase (\$_))
        {
            $valued_tokens{$_} = 1 ;
        }
        else
        {
#            print "$_\n" ;
            push @general_case, $_ ;
        }
    }

#    for (@general_case)
#    {
#        print "$_\n" ;
#    }

    my $general_case_valued_tokens_ref = getGeneralCaseScore (\@general_case, \$classifier) ;
    my @general_case_valued_tokens = %$general_case_valued_tokens_ref ;
    my @valued_tokens = %valued_tokens ;
    push @valued_tokens, @general_case_valued_tokens ;
    %valued_tokens = @valued_tokens ;

#    open F, "> scored_name" ;
#    while (my ($name, $score) = each %valued_tokens)
#    {
#        print F "$name $score\n" ;
#    }
#    close F ;
 
    \%valued_tokens ;
}

1 ;
