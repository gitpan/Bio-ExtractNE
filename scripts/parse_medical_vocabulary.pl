#!/usr/bin/perl

use strict;
use IO::All;

my $dir = $ARGV[0] || '.';
my $out = io('med.txt');
foreach my $file (glob("$dir/EXTRA.*")){
    my $text = io($file)->slurp;
    while($text =~ /\s+([\w']+)(?:\.\w)?\b/sg){
	my $term = $1;
	$term =~ s/_/ /g;
	$term =~ s/'s$//;
	$out->print($term,$/);
    }
}
