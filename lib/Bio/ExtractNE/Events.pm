package Bio::ExtractNE::Events;

use strict;
use Exporter::Lite;
use Bio::ExtractNE::EventPattern;
our @EXPORT = qw(extract_events);

sub extract_events {
    my $text = shift;
    my @e;
    push @e, $1 while $text =~ /\b($event_pattern)\b/go;
    @e;
}

1;
__END__

=head1 NAME

Bio::ExtractNE::Events - Detect interaction events in text


=head1 SYNOPSIS

 use Bio::ExtractNE::Events;

 @events = extract_events($text);

=head1 DESCRIPTION

This module can spot interaction events in English texts. The backend
algorithm is just simple regexp matching.

One function I<extract_events> is exported. After passing in text, it
returns a list of recognized interaction events.

=head1 SEE ALSO

Patterns of the events can be found in L<Bio::Extract::EventPattern>

=head1 COPYRIGHT

xern E<lt>xern@cpan.orgE<gt>

This module may be free software; perhaps you can redistribute it or
modify it under the same terms as Perl itself.

=cut
