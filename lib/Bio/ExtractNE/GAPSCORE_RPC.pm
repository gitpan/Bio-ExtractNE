package Bio::ExtractNE::GAPSCORE_RPC;

use strict ;

use Data::Dumper;
use RPC::XML::Client;

my $BIONLP = "http://bionlp.stanford.edu/xmlrpc";
my $threshold = 0.2; # see gapscore_rpc()

sub _find_gap_names ($) {
    my $text = shift;
    my $client = new RPC::XML::Client $BIONLP;
    my $res = $client->send_request('find_gene_and_protein_names', $text);
    return $res->value;
}

sub gapscore_rpc {
    my $me = shift;
    my %gapname;

    foreach my $s (@{$me->{sentence_ref}}){
	foreach my $n (@{_find_gap_names( $s)}){
	    $gapname{$n->[0]} = 1 if $n->[3] > $threshold;
	}
    }
    wantarray ? keys %gapname : [ keys %gapname ];
}

1;

__END__


# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Bio::ExtractNE::GAPSCORE_RPC - Class for accessing GAPSCORE RPC service

=head1 USAGE

    $me->gapscore_rpc();

This method return a list of recongnized names.

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2004 by Yung-chung Lin (a.k.a. xern) <xern@cpan.org>

This package is free software; you can redistribute it and/or modify
it under the same terms as Perl itself

=cut

