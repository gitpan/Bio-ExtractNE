package Bio::ExtractNE;

use strict;

use YAML;
use Data::Dumper;
use Exporter::Lite;
use Bio::ExtractNE::Dict;
use Bio::ExtractNE::Vars;
use Bio::ExtractNE::CommonWords;

our $VERSION = '1.03';

our @EXPORT;
our @ISA;

our $DICT;
our $USE_GAPSCORE_RPC = 0;
our $USE_GAPSCORE = 0;
our $USE_DICTIONARY = 1;
our $USE_SHORTEST = 0;

##################################################
# Load related submodules and exported subroutines
##################################################
foreach my $mod (qw(Tokenize GetAbst Recognizer GAPSCORE_RPC GAPSCORE)){
    no strict 'refs';
    eval 'use Bio::ExtractNE::'.$mod.';';
    die $@ if $@;
    push @EXPORT, @{"Bio::ExtractNE::".$mod."::EXPORT"};
    push @ISA, "Bio::ExtractNE::$mod";
}
push @EXPORT, qw(extractNE set_dictionary);

##################################################
# Load common word dictionary
##################################################
&load_commonwords();

sub set_dictionary {
    my $file = shift || $first_default_dictfile || $second_default_dictfile;
    die "Dictionary file <$file> does not exist" unless -e $file;
    $DICT = dict($file);
}

sub extractNE {
    my $input = shift;
    my %opt = @_;      # left for possible coming options.

    my $abstract = new_abstract($input)->{text};
    my $self = bless {}, 'Bio::ExtractNE'; # Actually, it has OO flesh
    my $data;

    if( $USE_DICTIONARY ){
	if( !ref $DICT ){
	    set_dictionary();
	    die "Please set the dictionary first" if !ref $DICT;
	}
	$self->{dict} = $DICT;


	# tokenize each sentence in texts
	# $token_ref is an array of tokens from each sentence.
	my $token_ref = $self->tokenize(\$abstract);
	
	# return segmented text with NE information
	# - sentence
	#  - tokens
	#  - named entities in each sentence
	#  - sentence numbers with interactions
	#  - abbreivation look-up data

	$data = $self->recognizer;
#	print Dumper $data->{NE};
    }

    # use self-implemented GAPSCORE
    if( $USE_GAPSCORE ){
	@{$data->{NE}} = (@{$data->{NE}}, @{$self->gapscore()});
    }
    # or use the GAPSCORE rpc module
    elsif( $USE_GAPSCORE_RPC ){
	@{$data->{NE}} = (@{$data->{NE}}, @{$self->gapscore_rpc()});
    }

    @{$data->{NE}} = grep { !&common_word($_) } @{$data->{NE}};
    @{$data->{NE}} = keys %{+{map{$_=>1} @{$data->{NE}}}};
    if( $USE_SHORTEST ){
	@{$data->{NE}}
	=
	    grep{$_}
	    keys %{+{
	    map{
		my $s = $self->{dict}->get_shortest_synonym($_);
		($s ? $s : $_) => 1
		}
	    @{$data->{NE}}}};
    }

    {
	sentence => $self->{sentence_ref},
	%$data,
    };
}



1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Bio::ExtractNE - Extract biological named entities from PUBMED abstracts

=head1 SYNOPSIS

    use Bio::ExtractNE;

=head2 SET DICTIONARY

Dictionary file defaults to /usr/local/Bio-ExtractNE/sprot.dict or
dict/sprot.dict

Usually, dictionary object is automatically built for you unless you
have dict files elsewhere.

    set_dictionary();
    set_dictionary('sprot.dict');


=head2 GET ABSTRACTS

Get abstracts by their PMID

    $abst = get_abstract('15043991');


=head2 EXTRACT NAMES

    use Data::Dumper;

Extract NE from abstract's body

    print Dumper extractNE($abst->{text});

Extract NE from abstract's title and body.

    print Dumper extractNE(join q/ /, @{$abst}{qw/title text/});

=head2 OPTIONS

Don't use dictionary. Default is I<YES>.

    $USE_DICTIONARY = 0;

Use the RPC service of GAPSCORE. Default is I<NO>.

    $USE_GAPSCORE_RPC = 1;

Use the self-implemented GAPSCORE. Default is I<NO>.

    $USE_GAPSCORE = 1;

Replace recognized named entities with their shortest
synonyms if they have them. Default is I<NO>

    $USE_SHORTEST = 1;


=head1 DESCRIPTION

This module can extract Named Entities from PUBMED online
abstracts. It recognizes protein names and gene names adapted from
SWISSPROT database. And it also tries to resolve on-the-spot
abbreviation reference, which means abbreviations in abstracts
bracketed between parentheses will be extracted too using a naive
looking-back method, though the technique is inelegant in some way
now.

For now, this package use GAPSCORE as its name guessing module. Both
an RPC interface and a self-implemented version are provided.

You can pass a PMID, a URL for abstract, an abstract passage, or an
abstract file to the extractNE() function. It then returns a list of
tokens, recognized named entities, abbreviations with their full
names, and sentence numbers in which there are potential
protein-protein interactions. But no categorical or synonym grouping
information of named entities is provided. Other classes of words,
such as disease names and virus names will be considered in future
versions.

Any suggestion or comment is always welcome. Contributions and
patches are wanted.

Email me if you have questions.


=head1 SEE ALSO

L<bene.pl>, a command-line tool for <Bio::ExtractNE> B<(Not done yet)>

For a similar function, see also L<Lingua::EN::NamedEntity>, except it
is written to deal with general English texts.

PUBMED, L<http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?db=PubMed>

SwissProt, L<http://expasy.org/>

Andy also, the related modules with this distribution:

L<Bio::ExtractNE::MakeDict>

L<Bio::ExtractNE::Dict>

L<Bio::ExtractNE::GetAbst>

L<Bio::ExtractNE::GetSprot>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2004 Yung-chung Lin (a.k.a. xern) <xern@cpan.org> and Chin-lin Peng

This package is free software; you can redistribute it and/or modify
it under the same terms as Perl itself

=cut
