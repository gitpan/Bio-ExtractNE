use Test::More tests => 3;

BEGIN{ use_ok('Bio::ExtractNE::Events') }

ok(extract_events('Therapy of human alpha 1 -AT deficiency requires stable transduction of resting hepatocytes, both to deliver wild-type alpha 1 -AT and to inhibit production of mutant alpha 1 -AT') == 1);

ok(extract_events('In resveratrol-treated cells, tumor necrosis factor (TNF), anti-CD95 antibodies and TNF-related apoptosis-inducing ligand (TRAIL) activate a caspase-dependent death pathway that escapes Bcl-2-mediated inhibition') == 4);
