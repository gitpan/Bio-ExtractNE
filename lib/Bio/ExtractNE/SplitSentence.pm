package Bio::ExtractNE::SplitSentence;

use Exporter::Lite;
our @EXPORT = qw(split_sentence);

sub split_sentence {
  my $text_ref = shift;
  my ($sentence, @ret);
  while($$text_ref =~ m,(.+?\.)(?=(?: [A-Z]|$)),g){
    ($sentence = $1) =~ s/^\s+(.+)\.$/$1/o;
    push @ret, $sentence;
  }
  \@ret;
}
1;
