package Bio::ExtractNE::GetSprot;

use strict;

use Exporter::Lite;
our @EXPORT = qw(get_sprot);

use LWP::Simple;


our $url='ftp://expasy.org/databases/swiss-prot/release_compressed/sprot43.dat.gz';

sub get_sprot {
    my $file = shift;
    if(!-e $file){
	my $sprot = get($url) or die "Cannot fetch $url";
	if($file){
	    open my $f, '>', $file or die "Cannot open $file";
	    binmode $f;
	    print {$f} $sprot;
	}
	$sprot;
    }
}


1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Bio::ExtractNE::GetSprot - Fetch Full SwissProt Data

=head1 SYNOPSIS

    use Bio::ExtractNE::GetAbst;
    get_sprot($outputfile);

=head1 DESCRIPTION

You can use this module to fetch the full database data from SwissProt to build a dictionary. In most cases, you need not do this yourself. Dictionary is already built for you. 

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2004 by Yung-chung Lin (a.k.a. xern) <xern@cpan.org> This package is free software; you can redistribute it and/or modify it under the same terms as Perl itself

=cut
