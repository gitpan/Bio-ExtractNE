use Bio::ExtractNE;
use Bio::ExtractNE::MakeDict;

set_dictionary('dict/sprot.dict');
mkcwdict(
	 [
	  "/usr/share/dict/words",
	  "med.txt",
	  ],
	   "common_words.db", "dict/sprot.dict"
	 );

