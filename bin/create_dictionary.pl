use Bio::ExtractNE::MakeDict;
use Bio::ExtractNE::Dict;

mkdict(
       {
	   sprot_file => "sprot",
       },
       "sprot.dict"
       );
if(-e "sprot.dict"){
    $dict = dict('sprot.dict');
    $dict->clear_stat();
    $dict->build_dict_index();
}
