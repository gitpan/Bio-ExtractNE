package Bio::ExtractNE::Dict;

=head1 NAME1

Bio::ExtractNE::Dict - Class for querying and processing dictionary

=head1 SYNOPSIS

=cut

use strict;
use DB_File;

=head2 INITIATION

    $d = dict($dictionary_file);

dict() returns an object of the dictionary with 3 addtional sub-dictionary database:

o I<lowercase db> (lc) stores the lowercased version of dictionary.

o I<head-word/first-word> db (hw) stores the first word of each
gene/protein names.

o I<maximum-length> db (ml) stores the maximum length of each
gene/protein names led by some head word.

=cut

use Exporter::Lite;
our @EXPORT = qw(
		 dict
		 );

sub dict {
    my $dictfile = shift or die;
    my %flag = map{$_=>1} @_;
    my %dict;
    my $x;

    unlink $dictfile if $flag{RESTART};

    $x = tie %dict,  'DB_File', $dictfile, O_RDONLY, 0644, $DB_BTREE;
    no strict 'refs';
    foreach (
	     # (
	     #  lowercase
	     #  head word
	     #  maximum length
	     # )
	     qw(lc hw ml)
	     ){
	${$_."_file"} = $dictfile.'.'.$_;
	unlink $dictfile.'.'.$_ if $flag{RESTART};
    }

    bless {
	   dict => \%dict,
	   dictx => $x,
	   dictfile => $dictfile,
	   map {
	     my $x = tie my %h, 'DB_File',
	       ${$_."_file"}, O_CREAT | O_RDWR, 0644, $DB_BTREE;
	     
	     $_ => \%h,
	       $_.'x' => $x,
	     } qw(
		  lc
		  hw
		  ml
		  )
	  }, 'Bio::ExtractNE::Dict';
}

=head2 QUERY

    $d->query($term);
    $d->query($term, $subdb);

By default, $subdb is ignored. Available options for $subdb are
I<lc>, I<hw>, I<ml>.

=cut

sub query {
    my ($self, $term, $db) = @_;
    my $value;
    if( $db && ref $self->{$db.'x'} ){
	$self->{$db.'x'}->get($term, $value);
    }
    else {
	$self->{dictx}->get($term, $value);
    }
    $value;
}

=head2 LOWERCASE QUERY

$term will be lowercased and sent to query().

    $d->query_lc($term);
    $d->query_lc($term, $subdb);

By default, $subdb is ignored. Available options for $subdb are
I<lc>, I<hw>, I<ml>.

=cut

sub query_lc {
    query($_[0], lc($_[1]), $_[2]);
}



sub clear_stat {
    my $self = shift;
    foreach my $suf (qw(hw ml)){
	while(my ($k, undef) = each %{$self->{$suf}}){
	    delete $self->{$suf}{$k};
	}
    }
}

=head2 BUILD INDEX FOR DICTIONARY

    $d->build_dict_index();

This function builds index for I<ml> and I<hw>, which speeds up
query.

=cut

sub build_dict_index {
    my $self = shift;
    my $x = $self->{dictx};
    my ($name, $v);
    my $num_name = 0;

    for (my $status = $x->seq($name, $v, R_FIRST) ;
	 $status == 0 ;
	 $status = $x->seq($name, $v, R_NEXT) )
    {
	my @tok = split / /o, $name;
	$self->{hw}{lc $tok[0]} = 1;
	$self->{ml}{lc $tok[0]} = scalar @tok if scalar @tok > $self->{ml}{$tok[0]};

	$num_name++;
    }

}

1;
__END__

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2004 by Yung-chung Lin (a.k.a. xern) <xern@cpan.org>

This package is free software; you can redistribute it and/or modify
it under the same terms as Perl itself

=cut
