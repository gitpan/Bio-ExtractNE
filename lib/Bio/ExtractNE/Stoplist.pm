package Bio::ExtractNE::Stoplist;

use Exporter::Lite;
our @EXPORT = qw(%stopword);


# this stoplist is adapted from  http://www.syger.com/jsc/docs/stopwords/english.htm
# and http://snowball.tartarus.org/english/stop.txt
our %stopword = map{$_=>1}
             qw(
		the an

		about above across afterwards after again against ago
		almost along already always among anywhere around as
		at away

		back before behind beside between beyond by

		down downstairs during

		else enough every everywhere

		far for from here in inside into just last lot lots
		many middle much

		near next never not nownowhere of off often ononce over
		outside over

		quite

		rather recentlyrarely round

		seldom sometimes somewhere

		there through till today to tomorrow tonight too
		towards

		until up upstairs usually under very

		while with within without

		yes yesterday yet

		you he she it we they

		me him her it us them

		myself yourself himself herself itself ourselves
		yourselves themselves oneself

		my your its our their mine yours hers ours theirs

		this these those

		some any no none other another every all others each
		whole both neither none someone somebody something
		anyone anybody anything nobody nothing everyone
		everybody everything

		and or but because if as like such though although

		how who why what where whose when whom which

		be was been am is are were can could come came comes
		do did done does get got gets have had has having may
		might must shall should ought take took taken takes
		taking use uses used will would aren't cannot can't
		couldn't didn't doesn't don't wasn't wouldn't hadn't
		isn't

		
		one two three four five six seven eight nine ten
		nought zero

		first second third fourth fifth sixth seventh eighth
		ninth tenth

		sunday monday tuesday wednesday thursday friday
		saturday

		january february march april may june july august
		september october november december

		date false e.g eg i.e ie etc example examples jr miss
		thing things true year

		bad big close difficult easy empty full good little
		long ready open short tall

		of at by for with about against between into through
		during before after above below to from up down in out
		on off over under upon per

		again further then once

		here there when where why how

		all any both each few more most other some such

		),

    qw( medline dna exon intron embryonic fibroblast mice mouse tube
	line
       );

1;
