package Bio::ExtractNE::Filter;

use strict;

use Exporter::Lite;
our @EXPORT = qw(token_filter);

use Bio::ExtractNE::Vars;

sub token_filter {
    my ($self) = @_;
    my $token_ref = $self->{token_ref};
    foreach my $sentence (@$token_ref){
	@$sentence =
	    grep
	    {
		!/^(
		    \d+
		    |
		    I{1..3}        # Roman numerals
		    |
		    $amino_pattern
		    |
		    $stoplist_pattern
		    )$/x
		    } @$sentence;
    }
    $token_ref;
}


1;
__END__
