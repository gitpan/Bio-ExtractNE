package Bio::ExtractNE::GetAbst;

use strict;

use LWP::Simple;
use Exporter::Lite;
use HTML::Entities;
use Regexp::Bind qw(bind);
use Regexp::Common qw /URI/;

our @EXPORT = qw(abstract
		 get_abstract
		 new_abstract
		 get_abstract_by_id
		 get_abstract_by_url);

my $abst_pattern = qr'
<br>
 <font\ssize="\+1"><b>(?#<title>.+?)</b></font><br><br>
 <b>(?#<author>.+?)</b><br><br>
 (?:(?#<organization>.+?)<br><br>)?
 (?#<text>.+?)<br><br>PMID:
'mx;

sub _abst_url {
    'http://www.ncbi.nlm.nih.gov/entrez/queryd.fcgi?cmd=Retrieve&db=pubmed&dopt=Abstract&list_uids='.$_[0];
}

sub _tidy_data {
    my $data = shift;
    local $_;
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
    my $url = shift;
    my $text = get($url) || return { text => undef };
    _tidy_data bind($text, $abst_pattern);
}


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
	open my $f, $input or die;
	return _tidy_data +{ text => <$f> };
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

=head1 USAGE

  use Bio::ExtractNE::GetAbst;

  get_abstract_by_id($PMID);
  get_abstract_by_url($URL);

  # the following functions are all the same
  get_abstract($PMID);        # return an abstract hash
  get_abstract($URL);
  get_abstract($ABSTRACT);

  new_abstract($PMID);
  new_abstract($URL);
  new_abstract($ABSTRACT);

  abstract($PMID);
  abstract($URL);
  abstract($ABSTRACT);


This module helps you fetch online abstracts on PUBMED. You can fetch
abstracts by PMID, URL, or the abstract body. All the functions above
return a hash of a PUBMED abstract.

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2004 by Yung-chung Lin (a.k.a. xern) <xern@cpan.org> This package is free software; you can redistribute it and/or modify it under the same terms as Perl itself

=cut
