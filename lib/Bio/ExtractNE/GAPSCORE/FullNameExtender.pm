package Bio::ExtractNE::GAPSCORE::FullNameExtender ;


use strict ;
use Exporter::Lite ;
use Lingua::EN::Tagger ;
use Regexp::List ;


our @EXPORT = qw (extendNames) ;

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

my $l  = Regexp::List->new ;

my $wanted_regular_expression = $l->list2re (@roman_numerals, @greek_letters) ;

sub extendNames
{
    my $lead_names_ref = shift ;

#    while (my ($key, $value) = each %$lead_names_ref)
#    {
#        print "($key, $value)\n" ;
#    }

#    my $tokens_ref = shift ;
    my $sentences_ref = shift ;

#    for (@$tokens_ref)
#    {
#        print "$_\n" ;
#    }

    my $tagger = Lingua::EN::Tagger->new ;

    my $full_name ;

    my $before_is_wanted = 1 ;
    my $before_is_name = 0 ;

    my %full_names ;
    my $score = 0 ;
    my $count = 0 ;

    my $names_regular_expression = $l->list2re (keys %$lead_names_ref) ;
#    print "$names_regular_expression\n" ;

    my @tagged_tokens ;
    for (@$sentences_ref)
    {
#        print "$_\n" ;
        my $tagged_sentence = $tagger->add_tags ($_) ;
        my @temp = split / /, $tagged_sentence ;
        push @tagged_tokens, @temp ;
    }
    
    my $is_balance = 1 ;
#    for (@$tokens_ref)
    
    for (@tagged_tokens)
    {
#        print "$_\n" ;
#        $_ = $tagger->add_tags ($_) ;
#        print "tagged token : $_\n" ;
#        print "before is name ? : $before_is_name\n" ;

        if ($before_is_name)
        {
            if ($_ =~ /^<.+>(\w|$wanted_regular_expression|$names_regular_expression)<\/.+>$/i)
            {
                $full_name .= " $1" ;
            }
            else
            {
                $full_names {$full_name} = ($score / $count) ;
                $before_is_name = 0 ;
                $full_name = "" ;
                $score = 0 ;
                $count = 0 ;
            }
        }
        else 
        {
            if ($_ =~ /^<.+>($names_regular_expression)<\/.+>$/i)
            {
                $before_is_name = 1 ;
                $score += $lead_names_ref->{$1} ;
                $count ++ ;

                if ($before_is_wanted)
                {
                    if ($full_name ne "")
                    {
                        $full_name .= " " ;
                    }

                    $full_name .= $1 ;
                }
                else
                {
                    $full_name = $1 ;
                }

                $before_is_wanted = 1 ;
            }
            elsif ($_ =~ /^<(jj.?|nn.*|prp.?|vbg|vbn|wp.?)>(.+)<\/\1>$/i)
            {
                #print "POS : $_\n" ;
                if ($before_is_wanted)
                {
                    if ($full_name ne "")
                    {
                        $full_name .= " " ;
                    }
 
                    $full_name .= $2 ;
                }
                else
                {
                    $full_name = $2 ;
                }

                $before_is_wanted = 1 ;
            }
            else
            {
                $before_is_wanted = 0 ;
            }
        }
    }

#    open F, "> scored_full_name" ;
#    while (my ($name, $score) = each %full_names)
#    {
#        print F "$name $score\n" ;
#    }
#    close F ;

    \%full_names ;
}

1 ;
