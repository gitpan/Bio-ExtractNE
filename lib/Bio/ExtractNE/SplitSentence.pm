package Bio::ExtractNE::SplitSentence;

use Exporter::Lite;
our @EXPORT = qw(split_sentence);

sub split_sentence {
  my $text_ref = shift;

  # Splitting rule is simple. A sentence boundary is a period
  # followed by either a blank char and an upper-case letter
  # or end of string
  my ($sentence, @ret);
  while($$text_ref =~ m,(.+?\.)(?=(?: [A-Z]|$)),go){
    # Remove leading blank chars and trailing period.
    ($sentence = $1) =~ s/^\s+(.+)\.$/$1/o;
    push @ret, $sentence;
  }
  \@ret;
}
1;
