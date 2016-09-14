package Armadito::Prelude;

use 5.008000;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);

our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	
);

our $VERSION = '0.0.2';

1;
__END__

=head1 NAME

Armadito::Prelude - Armadito-Prelude communication client in Perl language.

=head1 DESCRIPTION

Armadito-Prelude is a tool essentially developed to send Armadito Antivirus' virus alerts to Prelude SIEM.

=head1 SEE ALSO

Armadito AV documentation : L<http://armadito-av.readthedocs.io/en/latest/>

Prelude Website : L<https://www.prelude-siem.org/>

=head1 AUTHOR

vhamon, E<lt>vhamon@teclib.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2016 by Teclib'

=cut
