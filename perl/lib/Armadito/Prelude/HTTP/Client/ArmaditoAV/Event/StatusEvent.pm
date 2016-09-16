package Armadito::Prelude::HTTP::Client::ArmaditoAV::Event::StatusEvent;

use strict;
use warnings;
use base 'Armadito::Prelude::HTTP::Client::ArmaditoAV::Event';
use JSON;
use Data::Dumper;
use Armadito::Prelude::IDMEF qw( setAnalyzer setClassification setTarget setAssessment setAdditionalData );
use Armadito::Prelude::Tools::Time qw ( FormatTimestamp );

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

sub _setIDMEF {
	my ( $self, $message ) = @_;

	$self->{idmef}->setAnalyzer();

	if ( $self->{jobj}->{global_status} eq "up-to-date" ) {
		$self->{idmef}->setClassification( text => "Armadito Antivirus is up-to-date" );
		$self->{idmef}->setAssessment( impact_severity => "info" );
	}
	else {
		$self->{idmef}->setClassification( info => "Armadito Antivirus must be updated" );
		$self->{idmef}->setAssessment( impact_severity => "high" );
	}

	$self->{idmef}->setAssessment(
		impact_type        => "other",
		impact_completion  => "succeeded",
		impact_description => "Status for Armadito antivirus"
	);

	$self->{idmef}->setAdditionalData(
		i       => 0,
		type    => "string",
		meaning => "Antivirus status",
		data    => $self->{jobj}->{global_status}
	);

	$self->{idmef}->setAdditionalData(
		i       => 1,
		type    => "string",
		meaning => "Last update state",
		data    => FormatTimestamp( $self->{jobj}->{global_update_timestamp} )
	);

	return $self;
}

sub run {
	my ( $self, %params ) = @_;

	$self->_setIDMEF();
	$self->_sendToPrelude();
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
