package Bio::ExtractNE::SplitSentence;

use strict;
use Exporter::Lite;
our @EXPORT = qw(split_sentence);

sub split_sentence {
  my $text = ref($_[0]) ? ${$_[0]} : $_[0];

  # Splitting rule is simple. A sentence boundary is a period
  # followed by either a blank char and an upper-case letter
  # or end of string
  my (@tmp, @ret);
  $text =~ s/\n/ /go;
  push @tmp, $1 while $text =~ m,(.+?\.)(?=\s+(?:[A-Z]|$)),go;

  # these abbreviations are not sentence boundaries.
  my $abbrev = join q/|/, qw(e\.g i\.e esp aka q\.t s\.t usu);

  while (@tmp){
    my $s = shift @tmp;
    $s =~ s/^\s+//;
    $s = $s.shift( @tmp) while($s =~ /\b(?:$abbrev)\.$/);
    $s =~ s/\.$//o;
    push @ret, $s;
  }
  \@ret;
}
1;
