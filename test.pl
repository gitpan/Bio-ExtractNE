BEGIN { unshift @INC, '.' }
use Test::More qw(no_plan);
ok(1);

#print join $/, @INC;

use YAML;
use Bio::ExtractNE;

$id = 15043991;
ok($abst = get_abstract($id), 'Get abstract');

set_dictionary('dict/sprot.dict');
#set_dictionary();

$Bio::ExtractNE::USE_GAPSCORE_RPC = 1;
#$Bio::ExtractNE::USE_GAPSCORE = 1;
ok($data = extractNE($abst->{title}." ".$abst->{text}), 'Extract names');
YAML::DumpFile('tokens', $data);


__END__


use Bio::ExtractNE::CommonWords;
&load_commonwords;
my $word = 'test';
ok(common_word($word));
print $word, " is", common_word($word) ? "" : " not" , " a common word.\n";

__END__

use YAML;

$abst = get_abstract('15043991');
#YAML::DumpFile('abstract', $abst);

$s = YAML::Dump $token_ref =  extract($abst->{text});



__END__
15043991
15083067
15100181
15118165
15130783
15126349
15130709
