use Test::More qw(no_plan);
ok(1);
BEGIN{ use_ok('Bio::ExtractNE::Dict') }

$d = dict('dict/sprot.dict');
ok( $d->query('GRF5') );
ok( $d->query('General regulatory factor 5') );
is(~~$d->get_synonyms('14-3-3-like protein GF14 upsilon') => 3);
@a = $d->get_synonyms('14-3-3-like protein GF14 upsilon');
is($a[0] => 'GRF5');
is($a[1] => 'General regulatory factor 5');
is($a[2] => '14-3-3-like protein GF14 upsilon');
