package Bio::ExtractNE::HandPicked;


use strict;
use DB_File;
use Exporter::Lite;

our @EXPORT = qw(
		 &insert_hand_picked
		 &delete_hand_picked
		 );

our @addenda =
  grep {$_} 
  split /\n/, <<'.';
cyclic adenosine monophosphate
NF-kappaB
NF kappa B
NF-kappa B
actin
IkappaB
pIkappaBalpha-E3
Rho A
insulin
.

our @delenda =
  grep {$_} 
  split /\n/, <<'.';
Self-incompatibility
junction
Headpiece
photodynamic therapy
protein kinase
protein kinases
receptor
receptors
long terminal repeat
.

sub insert_hand_picked {
    my $dictfile = shift or die;
    my $lc_dictfile = "$dictfile.lc";  # lowercase
    my ( %dict, %lc_dict);
    if($dictfile){
        tie %dict,  'DB_File', $dictfile, O_CREAT | O_WRONLY, 0644, $DB_BTREE;
        tie %lc_dict,  'DB_File', $lc_dictfile, O_CREAT | O_WRONLY, 0644, $DB_BTREE;
    }
    foreach my $entry (@addenda){
        $dict{$entry} = 1;
        $lc_dict{lc $entry} = $entry;
    }
}


sub delete_hand_picked {
    my $dictfile = shift or die;
    my $lc_dictfile = "$dictfile.lc";  # lowercase
    my ( %dict, %lc_dict);
    if($dictfile){
        tie %dict,  'DB_File', $dictfile, O_CREAT | O_RDWR, 0644, $DB_BTREE;
        tie %lc_dict,  'DB_File', $lc_dictfile, O_CREAT | O_RDWR, 0644, $DB_BTREE;
    }
    foreach my $entry (@delenda){
        delete $dict{$entry};
        delete $lc_dict{lc $entry};
    }
}

1;


1;
__END__
