use Test::More qw(no_plan);
BEGIN{ use_ok('Bio::ExtractNE::SplitSentence'); }

$text = <<'.';
INTRODUCTION: An increasing number of elderly patients, with acute respiratory failure (ARF) due to e.g. COPD exacerbation or cardiac failure, are being referred to intensive care units for mechanical ventilation. STATE OF ART: NIV can be an effective ventilatory technique in ARF due to a variety of aetiologies. NIV has been shown to decrease endotracheal intubation rates, complication rates and median hospital length of stay. When managing acute-on-chronic respiratory failure, NIV is a first-line ventilatory technique, in the absence of criteria for immediate endotracheal intubation. The efficacy of NIV depends on the expertise of the medical and nursing staff (including physiotherapists) and should always be performed in an appropriate setting. There are very few data about NIV in the elderly but studies, which included patients over 75 years, did not identify different outcomes for this age group. PERSPECTIVES: Future clinical studies on NIV should allow us to better understand which patients will benefit the most from the technique. Certain specific settings in elderly populations, such as in palliative care or when an "non intubation order" has been given by the patient, his family or the medical/nursing staff, are under evaluation. CONCLUSIONS: NIV is effective and well tolerated and it has become a key ventilatory technique in the management of ARF, particularly for elderly patients.
.
@desired_input = grep{$_}split /\n/,<<'.';
INTRODUCTION: An increasing number of elderly patients, with acute respiratory failure (ARF) due to e.g. COPD exacerbation or cardiac failure, are being referred to intensive care units for mechanical ventilation
STATE OF ART: NIV can be an effective ventilatory technique in ARF due to a variety of aetiologies
NIV has been shown to decrease endotracheal intubation rates, complication rates and median hospital length of stay
When managing acute-on-chronic respiratory failure, NIV is a first-line ventilatory technique, in the absence of criteria for immediate endotracheal intubation
The efficacy of NIV depends on the expertise of the medical and nursing staff (including physiotherapists) and should always be performed in an appropriate setting
There are very few data about NIV in the elderly but studies, which included patients over 75 years, did not identify different outcomes for this age group
PERSPECTIVES: Future clinical studies on NIV should allow us to better understand which patients will benefit the most from the technique
Certain specific settings in elderly populations, such as in palliative care or when an "non intubation order" has been given by the patient, his family or the medical/nursing staff, are under evaluation
CONCLUSIONS: NIV is effective and well tolerated and it has become a key ventilatory technique in the management of ARF, particularly for elderly patients
.

use Data::Dumper;
@r = @{split_sentence($text)};
#print join qq/\n/, @r;
foreach (0..$#r){
	is($r[$_] => $desired_input[$_]);
}