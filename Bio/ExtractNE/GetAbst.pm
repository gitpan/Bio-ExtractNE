package Bio::ExtractNE::GetAbst;

use strict;

use Exporter::Lite;
our @EXPORT = qw(
		 get_abstract_by_id
		 get_abstract_by_url
		 get_abstract
		 new_abstract
		 abstract
		 );

use Bio::ExtractNE::Vars;

use LWP::Simple;
use HTML::Entities;
use Regexp::Bind qw(bind);


sub _abst_url {
    'http://www.ncbi.nlm.nih.gov/entrez/queryd.fcgi?cmd=Retrieve&db=pubmed&dopt=Abstract&list_uids='.$_[0];
}

sub _tidy_data {
    my $data = shift;
    $_ = decode_entities($_) foreach values %$data;
    $data->{text} =~ s/<br><br>/ /o;
    $data;
}

sub get_abstract_by_id {
    my $id = shift;
    my $text = get(_abst_url($id)) || return { text => undef };
    _tidy_data bind($text, $abst_pattern);
}

sub get_abstract_by_url {
    my $id = shift;
    my $text = get($id) || return { text => undef };
    _tidy_data bind($text, $abst_pattern);
}

use Regexp::Common qw /URI/;


sub abstract {
    my $input = shift;
    if($input =~ /^\d+$/o){
	return get_abstract_by_id($input);
    }
    elsif($input =~ /$RE{URI}{HTTP}/o){
	return get_abstract_by_url($input);
    }
    elsif(-r $input) {
	local $/;
	my $f;
	return _tidy_data +{ text => (open($f, $input or die), <$f>) };
    }
    _tidy_data +{ text => $input };
}
*get_abstract = \&abstract;
*new_abstract = \&abstract;

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Bio::ExtractNE::GetAbst - Fetch abstracts from PUBMED

=head1 SYNOPSIS

  use Bio::ExtractNE::GetAbst;

  get_abstract_by_id($PMID);
  get_abstract_by_url($URL);

  # the following functions are all the same
  get_abstract($PMID);        # return an anonymous hash for abstract
  get_abstract($URL);
  get_abstract($ABSTRACT);

  new_abstract($PMID);        # return an anonymous hash for abstract
  new_abstract($URL);
  new_abstract($ABSTRACT);

  abstract($PMID);            # return an anonymous hash for abstract
  abstract($URL);
  abstract($ABSTRACT);


=head1 DESCRIPTION

This module helps you fetch online abstracts on PUBMED. You can fetch abstracts by PMID, URL, or the abstract body.

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2004 by Yung-chung Lin (a.k.a. xern) <xern@cpan.org> This package is free software; you can redistribute it and/or modify it under the same terms as Perl itself

=cut
