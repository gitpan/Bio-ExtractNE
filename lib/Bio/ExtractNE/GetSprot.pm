package Bio::ExtractNE::GetSprot;

use strict;

use LWP::Simple;
use File::Which;
use Exporter::Lite;

our @EXPORT = qw(get_sprot);


sub get_sprot {
    my $outputfile = shift || die "Please specify output file's name";
    my $uncompress = shift;
    my $url='ftp://expasy.org/databases/swiss-prot/release_compressed/sprot44.dat.gz';
    getstore($url, $outputfile);
    die "Cannot fetch Swissprot data" if !-e $outputfile;
    if($uncompress){
	$outputfile .= '.gz' if $outputfile !~ /\.gz$/;
	system(~~which('gunzip'), $outputfile);
    }
}


1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Bio::ExtractNE::GetSprot - Fetch Full SwissProt Data

=head1 SYNOPSIS

    use Bio::ExtractNE::GetAbst;

    get_sprot($outputfile);    # get the file, but no uncompression

    get_sprot($outputfile, 1); # get the file and uncompress it

=head1 DESCRIPTION

You can use this module to fetch the full database data from SwissProt
to build a dictionary. In most cases, you need NOT do this
yourself. Dictionary is already built for you. See I<dict/>.

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2004 by Yung-chung Lin (a.k.a. xern) <xern@cpan.org>
This package is free software; you can redistribute it and/or modify
it under the same terms as Perl itself

=cut
