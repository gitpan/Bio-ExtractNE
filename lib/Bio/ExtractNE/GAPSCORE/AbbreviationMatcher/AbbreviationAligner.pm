package Bio::ExtractNE::GAPSCORE::AbbreviationMatcher::AbbreviationAligner ;


use strict ;
use Exporter::Lite ;


our @EXPORT = qw (alignAbbreviation) ;

sub alignAbbreviation 
{
    my ($a, $b) = @_ ;
    my (@x, @y) ;
    my ($maxLength, $maxXi, $maxXk, $switch) = (0, 0, 0, 0) ;
    my $returnString ;

    my $m = length $a ;
    my $n = length $b ;

    if ($m > $n) 
    {
        ($m, $n) = ($n, $m) ;
        ($a, $b) = ($b, $a) ;
        $switch = 1 ;
    }

    @x = split //, $a ;	
    @y = split //, $b ;

    my ($i, $ii, $j, $k, $length, $xi, $xj) ;

    for ($k = 0; $k < $n; $k++)
    {
        last if ($maxLength >= ($m - $k)) ;

        ($xi, $length) = (0, 0) ;

        for ($i = 0; $i < $m ; $i++)
        {
            $j = $k ;
#            $length = 0 ;
            for ($ii = 0; $ii < ($m-$i); $ii++)
            {
#                print "$maxLength\n" ;
                if ($x[$i+$ii] eq $y[$j])
                {
                    $xi = $i+$ii unless ($length) ;
                    $xj = $j unless ($length) ;
                    $length++ ;
                    $j++ ;
                }
                elsif ($length)
                {
                    if ($length > $maxLength)
                    {
                        #print "$length\n" ;
                        $maxLength = $length ;
                        $maxXi = $xi ;
                        $maxXk = $xj ;
                    }
                    last ;
                }
            }
        }
    }

#    print "$maxLength\n" ;
    if ($maxLength > 1)
    {
        for ($i = $maxXi; $i < $maxXi+$maxLength; $i++)
        {
	    $returnString .= $x[$i] ;
	}
        ($maxXi, $maxXk) = ($maxXk, $maxXi) if ( $switch ) ;
    }

    (wantarray) ? ($returnString, $maxXi, $maxXk) :  $returnString ;
}

1 ;
