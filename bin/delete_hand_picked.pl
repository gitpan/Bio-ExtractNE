use Bio::ExtractNE::HandPicked;
use Bio::ExtractNE::Dict;

delete_hand_picked("dict/sprot.dict");

$dict = dict('dict/sprot.dict');
$dict->clear_stat();
$dict->build_dict_index();
