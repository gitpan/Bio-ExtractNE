package Bio::ExtractNE;

use strict;

use Exporter::Lite;
our @EXPORT;
our $VERSION = '1.00';

use Data::Dumper;

use Bio::ExtractNE::Dict;
our $DICT;


our @PARENT_MODULE = qw(
			Tokenize
			GetAbst
			Recognizer
			GAPSCORE_RPC
			GAPSCORE
			);
our @ISA;
foreach my $mod (@PARENT_MODULE){
    no strict 'refs';
    eval 'use Bio::ExtractNE::'.$mod.';';
    die $@ if $@;
    push @EXPORT, @{"Bio::ExtractNE::".$mod."::EXPORT"};
    push @ISA, "Bio::ExtractNE::$mod";
}

push @EXPORT, qw(extractNE set_dictionary);
use YAML;

sub set_dictionary {
    my $file = shift || '/usr/local/Bio-ExtractNE/sprot.dict';
    die "The file <$file> does not exist" unless -e $file;
    $DICT = dict($file);
}

our $USE_GAPSCORE_RPC = 0;
our $USE_GAPSCORE = 0;
our $USE_DICTIONARY = 1;

use Bio::ExtractNE::CommonWords;
&load_commonwords();

sub extractNE {
    my $input = shift;
    my %opt = @_;      # left for possible coming options.

    my $abstract = new_abstract($input)->{text};
    my $self = bless {}, 'Bio::ExtractNE';
    my $data;

    if( $USE_DICTIONARY ){
	die "Please set the dictionary first" if !ref $DICT;
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

    # Dictionary file defaults to /usr/local/Bio-ExtractNE/sprot.dict
    set_dictionary();
    set_dictionary('sprot.dict');

=head2 GET ABSTRACTS

    # Get abstracts by their PMID
    $abst = get_abstract('15043991');


=head2 EXTRACT NAMES

    use Data::Dumper;

    # Extract NE from abstract's body
    print Dumper extractNE($abst->{text});

    # Extract NE from abstract's title and body.
    print Dumper extractNE(join q/ /, @{$abst}{qw/title text/});

=head2 OPTIONS

    # Don't use the dictionary. Default is yes.
    $USE_DICTIONARY = 0;

    # Use the RPC service of GAPSCORE. Default is no.
    $USE_GAPSCORE_RPC = 1;

    # Use the self-implemented GAPSCORE. Default is no.
    $USE_GAPSCORE = 1;


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

GAPSCORE, L<http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?cmd=Retrieve&db=pubmed&dopt=Abstract&list_uids=14734313>
PUBMED, L<http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?db=PubMed>

SwissProt, L<http://expasy.org/>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2004 Yung-chung Lin (a.k.a. xern) <xern@cpan.org> and Chin-lin Peng

This package is free software; you can redistribute it and/or modify
it under the same terms as Perl itself

=head1 CAVEAT!

The whole module is in a totally gross state. Need to do lots of
improvement and code clean-up later.


=cut
