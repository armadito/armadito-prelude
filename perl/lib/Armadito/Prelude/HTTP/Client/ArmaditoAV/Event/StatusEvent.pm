package Armadito::Prelude::HTTP::Client::ArmaditoAV::Event::StatusEvent;

use strict;
use warnings;
use base 'Armadito::Prelude::HTTP::Client::ArmaditoAV::Event';
use JSON;
use Data::Dumper;
use Armadito::Prelude::IDMEF qw( setAnalyzer setClassification setTarget setAssessment setAdditionalData );

sub new {
	my ( $class, %params ) = @_;

	my $self = $class->SUPER::new(%params);

	$self->{idmef} = Armadito::Prelude::IDMEF->new();

	return $self;
}

sub _sendToPrelude {
	my ( $self, $message ) = @_;

	$self->{prelude_client}->{client}->sendIDMEF( $self->{idmef}->{obj} );

	return $self;
}

sub run {
	my ( $self, %params ) = @_;

	print Dumper( $self->{jobj} );

	$self->{idmef}->setAnalyzer();

	# $self->_sendToPrelude();
	$self->{end_polling} = 1;

	return $self;
}
1;

__END__

=head1 NAME

Armadito::Prelude::HTTP::Client::ArmaditoAV::Event::StatusEvent - ArmaditoAV StatusEvent class

=head1 DESCRIPTION

This is the class dedicated to StatusEvent of ArmaditoAV api.

=head1 FUNCTIONS

=head2 run ( $self, %params )

Run event related stuff. Send ArmaditoAV status to Armadito Plugin for GLPI.

=head2 new ( $class, %params )

Instanciate this class.
