package Armadito::Prelude::IDMEF;

use strict;
use warnings;
use English qw(-no_match_vars);
use UNIVERSAL::require;
use Prelude;

require Exporter;

sub new {
	my ( $class, %params ) = @_;

	my $self = {};
	$self->{obj} = Prelude::IDMEF->new();

	bless $self, $class;
	return $self;
}

sub setFromXML {
	my ( $self, %params ) = @_;

	$self->_setAnalyzer( $params{xml} );
	$self->_setClassification( $params{xml} );
	$self->_setTarget( $params{xml} );
	$self->_setAssessment( $params{xml} );
	$self->_setAdditionalData( $params{xml} );

	return $self;
}

sub _getLevelStr {
	my ( $self, $level ) = @_;

	return
		  $level eq "2" ? "high"
		: $level eq "1" ? "medium"
		: $level eq "0" ? "low"
		:                 "info";
}

sub _setAnalyzer {
	my ( $self, $xml ) = @_;

	$self->{obj}->set( "alert.analyzer(0).name",         "Armadito antivirus" );
	$self->{obj}->set( "alert.analyzer(0).manufacturer", "www.teclib.com" );
	$self->{obj}->set( "alert.analyzer(0).class",        "Antivirus" );
	$self->{obj}->set( "alert.analyzer(0).process.name", $xml->{alert}->{identification}->{process}->{value} );
	$self->{obj}->set( "alert.analyzer(0).process.pid",  $xml->{alert}->{identification}->{pid}->{value} );

	return $self;
}

sub _setClassification {
	my ( $self, $xml ) = @_;

	$self->{obj}->set( "alert.classification.text", "Virus found: " . $xml->{alert}->{module_specific}->{value} );

	return $self;
}

sub _setTarget {
	my ( $self, $xml ) = @_;

	$self->{obj}->set( "alert.target(0).process.name",          $xml->{alert}->{identification}->{process}->{value} );
	$self->{obj}->set( "alert.target(0).process.pid",           $xml->{alert}->{identification}->{pid}->{value} );
	$self->{obj}->set( "alert.target(0).user.category",         "application" );
	$self->{obj}->set( "alert.target(0).user.user_id(0).name",  $xml->{alert}->{identification}->{user}->{value} );
	$self->{obj}->set( "alert.target(0).node.name",             $xml->{alert}->{identification}->{hostname}->{value} );
	$self->{obj}->set( "alert.target(0).node.address.category", "ipv4-addr" );
	$self->{obj}->set( "alert.target(0).node.address.address",  $xml->{alert}->{identification}->{ip}->{value} );

	return $self;
}

sub _setAssessment {
	my ( $self, $xml ) = @_;

	$self->{obj}->set( "alert.assessment.impact.severity",    $self->_getLevelStr( $xml->{alert}->{level}->{value} ) );
	$self->{obj}->set( "alert.assessment.impact.type",        "file" );
	$self->{obj}->set( "alert.assessment.impact.completion",  "succeeded" );
	$self->{obj}->set( "alert.assessment.impact.description", "Virus detected by Armadito AV on-access protection" );

	return $self;
}

sub _setAdditionalData {
	my ( $self, $xml ) = @_;

	$self->{obj}->set( "alert.additional_data(0).type",    "string" );
	$self->{obj}->set( "alert.additional_data(0).meaning", "File location" );
	$self->{obj}->set( "alert.additional_data(0).data",    $xml->{alert}->{uri}->{value} );

	$self->{obj}->set( "alert.additional_data(1).type",    "string" );
	$self->{obj}->set( "alert.additional_data(1).meaning", "Virus name" );
	$self->{obj}->set( "alert.additional_data(1).data",    $xml->{alert}->{module_specific}->{value} );

	return $self;
}
1;

__END__

=head1 NAME

Armadito::Prelude::IDMEF - Class dealing with IDMEF format for libprelude

=head1 DESCRIPTION

This is the class used for the creation of new IDMEF alerts from parsed XML objects.

=head1 METHODS

=head2 $idmef->new(%params)

Instanciate Prelude IDMEF object.

=head2 $idmef->setFromXML()

Set a new IDMEF from a given parsed XML. It uses Perl prelude library API.

=head1 SEE ALSO

See L<RFC 4765|https://www.ietf.org/rfc/rfc4765.txt> for further information about IDMEF format.
