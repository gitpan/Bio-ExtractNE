package Bio::ExtractNE::Dict;

=head1 NAME1

Bio::ExtractNE::Dict - Class for querying and processing dictionary

=head1 SYNOPSIS

=cut

use strict;
use DB_File;
use Exporter::Lite;
use File::Basename;
use Bio::ExtractNE::Vars;
use File::Spec::Functions;

our @EXPORT = qw(dict);

=head2 INITIATION

    use Bio::ExtractNE::Dict;
    $d = dict($dictionary_file);

Dictionary file defaults to /usr/local/Bio-ExtractNE/sprot.dict or
dict/sprot.dict.

You can set env variable $ENV{BENEDICTPATH} to others if
you need to use the dictionary installed somewhere else temporarily.

    # An example with bash
    > export BENEDICTPATH=/home/my.name/Bio-ExtractNE/


dict() returns an object of the dictionary with several addtional
sub-dictionary database:

o I<lowercase db> (lc) stores the lowercased version of dictionary.

o I<head-word/first-word> db (hw) stores the first word of each
gene/protein names.

o I<maximum-length> db (ml) stores the maximum length of each
gene/protein names led by some head word.

o I<synonym> db (sn) stores pointers to representatives of synonyms.

o I<inverted synonym list> db (sl) stores lists of synonyms related to
proteins.

=cut


sub dict {
    my $dictfile = shift || $first_default_dictfile || $second_default_dictfile;
    my $dictdir = dirname($dictfile);

    my %flag = map{$_=>1} @_;
    my @subdb = qw(lc ml hw sn sl);
    my @dbargs = (O_RDONLY, 0644, $DB_BTREE);

    my $x = tie my %dict,  'DB_File', $dictfile, @dbargs
	or die "Cannot tie to dictionary file $!";
    no strict 'refs';
    foreach (@subdb){
	${$_."_file"} = $dictfile.'.'.$_;
    }
    my $cwx = tie my %cwdict, 'DB_File', catfile($dictdir, 'common_words.dict'),
    @dbargs or die "Cannot tie to common word dictionary $!";
    


    bless {
	dictfile => $dictfile,

	dict => \%dict,
	dictx => $x,

	cwdict => \%cwdict,
	cwx => $cwx,

	# sub-dbs for dictionary
	map {
	    my $x = tie my %h, 'DB_File', ${$_."_file"}, @dbargs
		or die "Cannot tie to subdb ".${$_."_file"};
	    $_ => \%h,
	    $_.'x' => $x } @subdb
	}, 'Bio::ExtractNE::Dict';
}

=head2 QUERY

    $d->query($term);
    $d->query($term, $subdb);

Default dictionary for query is the main one. Available options for
$subdb are I<lc>, I<hw>, I<ml>, I<sn>, I<sl>, I<cw>.

=cut

sub query {
    my ($self, $term, $db) = @_;
    my $value;
    ( ($db && ref($self->{$db.'x'})) ?
      $self->{$db.'x'} : $self->{dictx} )->get($term => $value) == 0;
}

=head2 LOWERCASE QUERY

$term will be lowercased and sent to query().

    $d->query_lc($term);
    $d->query_lc($term, $subdb);

=cut

sub query_lc { query($_[0], lc($_[1]), $_[2]) }

=head2 RETRIEVE SYNONYMS

This method is to get synonyms of a known protein name (Case-sensitive).

In list context, an array of synonyms is returned.

    @syn = $d->get_synonyms($term);

In scalar context, returned is the number of synonyms.

    $syn = $d->get_synonyms($term);

Another method I<get_shortest_synonym()> can help to get the shortest
one in a synonym set.

    $shortest_syn = $d->get_shortest_synonym($term);

=cut

sub get_synonyms {
    my ($self, $term) = @_;
    my ($synroot, $synstr, @synlist);
    $self->{snx}->get($term => $synroot);
    if($synroot){
	$self->{slx}->get($synroot => $synstr);
	@synlist = ($synroot, split /\x0/, $synstr);
    }
    wantarray ? @synlist : scalar(@synlist);
}

sub get_shortest_synonym {
    my ($self, $term) = @_;
    $self->{snx}->get($term => my $synroot);
    $synroot;
}

=head2 COMMON WORD CHECKING

    $d->is_common_word($query);

This method checks if the given query is existent in common word dictionary.


=cut

sub is_common_word { query($_[0], $_[1], 'cw') }

1;
__END__

=head1 SEE ALSO

Please go to read the source of L<Bio::ExtractNE::MakeDict> when you
have problem this document.

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2004 by Yung-chung Lin (a.k.a. xern) <xern@cpan.org>

This package is free software; you can redistribute it and/or modify
it under the same terms as Perl itself

=cut
