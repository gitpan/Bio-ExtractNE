use Test::More qw(no_plan);
ok(1);

use YAML;
use Bio::ExtractNE;

$id = 15043991;
$abst = get_abstract($id);

set_dictionary('dict/sprot.dict');

#$Bio::ExtractNE::USE_GAPSCORE_RPC = 1;
#$Bio::ExtractNE::USE_GAPSCORE = 1;
#$Bio::ExtractNE::USE_SHORTEST = 1;
ok($data = extractNE($abst->{title}." ".$abst->{text}), 'Extract names');
YAML::DumpFile('tokens', $data);


__END__
