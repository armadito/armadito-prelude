package Armadito::Prelude::HTTP::Client::ArmaditoAV::Event::DetectionEvent;

use strict;
use warnings;
use base 'Armadito::Prelude::HTTP::Client::ArmaditoAV::Event';
use Armadito::Prelude::IDMEF;

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
	$self->{idmef}->setClassification( text => "Virus found: " . $self->{jobj}->{module_report} );

	$self->{idmef}->setAssessment(
		impact_severity    => "high",
		impact_type        => "file",
		impact_completion  => "succeeded",
		impact_description => "Virus detected by Armadito AV (on-demand scan)"
	);

	$self->{idmef}->setAdditionalData(
		i       => 0,
		type    => "string",
		meaning => "File location",
		data    => $self->{jobj}->{path}
	);

	$self->{idmef}->setAdditionalData(
		i       => 1,
		type    => "string",
		meaning => "Virus name",
		data    => $self->{jobj}->{module_report}
	);

	return $self;
}

sub run {
	my ( $self, %params ) = @_;

	$self->_setIDMEF();
	$self->_sendToPrelude();
	return $self;
}
1;

__END__

=head1 NAME

Armadito::Prelude::HTTP::Client::ArmaditoAV::Event::DetectionEvent - ArmaditoAV DetectionEvent class

=head1 DESCRIPTION

This is the class dedicated to DetectionEvent of ArmaditoAV api.

=head1 FUNCTIONS

=head2 run ( $self, %params )

Run event related stuff.

=head2 new ( $class, %params )

Instanciate this class.

