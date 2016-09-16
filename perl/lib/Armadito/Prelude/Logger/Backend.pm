package Armadito::Prelude::Logger::Backend;

use strict;
use warnings;

1;
__END__

=head1 NAME

Armadito::Prelude::Logger::Backend - An abstract logger backend

=head1 DESCRIPTION

This is an abstract base classe for logger backends.

=head1 METHODS

=head2 new(%params)

The constructor. The following parameters are allowed, as keys of the $params
hashref:

=over

=item I<config>

the agent configuration object

=back

=head2 addMessage(%params)

Add a log message, with a specific level. The following arguments are allowed:

=over

=item I<level>

Can be one of:

=over

=item debug

=item info

=item warning

=item error

=back

=item I<message>

=back
