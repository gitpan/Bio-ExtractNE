use Test::More qw(no_plan);
BEGIN{ use_ok('Bio::ExtractNE::GetAbst') }

my $PMID = 15479477;
my $URL = 'http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?cmd=Retrieve&db=pubmed&dopt=Abstract&list_uids=15479477';

like(get_abstract($PMID)->{title}
	 => qr(The evolution of drug-activated), 'Get abstract by PMID');

like(get_abstract($URL)->{title}
	 => qr(The evolution of drug-activated), 'Get abstract by URL');


$Bio::ExtractNE::GetAbst::USE_ARRAY = 1;
like(get_abstract($URL)->[0]
	 => qr(The evolution of drug-activated), 'Get abstract by URL');

