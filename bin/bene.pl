#!/usr/bin/perl

use YAML;
use Bio::ExtractNE;

set_dictionary($ENV{BENEDICT}) if $ENV{BENEDICT};

$id = 15043991;
ok($abst = get_abstract($id), 'Get abstract');


#$Bio::ExtractNE::USE_GAPSCORE_RPC = 0;
#$Bio::ExtractNE::USE_GAPSCORE = 1;

ok($data = extractNE($abst->{title}." ".$abst->{text}), 'Extract names');
YAML::DumpFile('tokens', $data);



__END__

=head1 NAME

bene.pl - A command-line tool for Bio::ExtractNE

=head1 OPTIONS

   -d      Download abstracts (boolean option)
   -e      Extract named entities only
   -A      Output directory for fetched abstracts
   -i      PMID  (You can pass in multiple IDs)
   -f      Extract from abstract file or download PMIDs in the file.
   -E      Output directory for extracted named entities.
   -D      Data dumping method: (YAML or Data::Dumper) (Defaults to YAML)

Non-existing directories are created automatically.

=head1 EXAMPLES

Fetch PMID 15043991, store the abstract in ./abstracts/, and
extract named entites in ./named_entities

 > bene.pl -e -i 15043991 -A ./abstracts/ -E ./named_entities

Download PMIDs that are in PMID_FILE, and store abstracts in
./abstracts

 > bene.pl -d -f PMID_FILE

 > bene.pl -d -f PMID_FILE -A ./abstracts/

 > bene.pl -e -A ./abstracts/ -E ./named_entities

=head1 SEE ALSO

L<Bio::ExtractNE>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2004 Yung-chung Lin (a.k.a. xern) <xern@cpan.org> and
Chin-lin Peng

This package is free software; you can redistribute it and/or modify
it under the same terms as Perl itself


=cut
