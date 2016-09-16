package Armadito::Prelude::Client;

use strict;
use warnings;
use English qw(-no_match_vars);
use UNIVERSAL::require;
use Prelude;

require Exporter;

sub new {
	my ( $class, %params ) = @_;

	my $self = {
		name   => $params{name},
		client => Prelude::ClientEasy->new( $params{name} )
	};

	bless $self, $class;
	return $self;
}

sub start {
	my ( $self, %params ) = @_;

	$self->{client}->start();

	return $self;
}
1;

__END__

=head1 NAME

Armadito::Prelude::Client - Client class dealing with libprelude with Prelude module.

=head1 DESCRIPTION

This is the class used by Armadito Prelude agent to communicate with Prelude server.

=head1 METHODS

=head2 $client->new(%params)

Instanciate Prelude ClientEasyClass.

=over

=item I<name>

Name of the prelude client used when register with prelude server.

=back

=head2 $client->start()

Starts the client.

