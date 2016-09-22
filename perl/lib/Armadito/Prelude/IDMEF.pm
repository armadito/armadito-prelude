package Armadito::Prelude::IDMEF;

use strict;
use warnings;
use English qw(-no_match_vars);
use UNIVERSAL::require;
use Prelude;

require Exporter;

our @EXPORT_OK = qw( setAnalyzer setClassification setTarget setAssessment setAdditionalData );

sub new {
	my ( $class, %params ) = @_;

	my $self = {};
	$self->{obj} = Prelude::IDMEF->new();

	bless $self, $class;
	return $self;
}

sub setFromXML {
	my ( $self, %params ) = @_;

	$self->setAnalyzer(
		process_name => $params{xml}->{alert}->{identification}->{process}->{value},
		process_pid  => $params{xml}->{alert}->{identification}->{pid}->{value}
	);

	$self->setClassification( text => "Virus found: " . $params{xml}->{alert}->{module_specific}->{value} );

	$self->setTarget(
		i                     => 0,
		process_name          => $params{xml}->{alert}->{identification}->{process}->{value},
		process_pid           => $params{xml}->{alert}->{identification}->{pid}->{value},
		user_category         => "application",
		user_id               => $params{xml}->{alert}->{identification}->{user}->{value},
		node_name             => $params{xml}->{alert}->{identification}->{hostname}->{value},
		node_address_category => "ipv4-addr",
		node_address          => $params{xml}->{alert}->{identification}->{ip}->{value}
	);

	$self->setAssessment(
		impact_severity    => $self->_getLevelStr( $params{xml}->{alert}->{level}->{value} ),
		impact_type        => "file",
		impact_completion  => "succeeded",
		impact_description => "Virus detected by Armadito AV"
	);

	$self->setAdditionalData(
		i       => 0,
		type    => "string",
		meaning => "File location",
		data    => $params{xml}->{alert}->{uri}->{value}
	);

	$self->setAdditionalData(
		i       => 1,
		type    => "string",
		meaning => "Virus name",
		data    => $params{xml}->{alert}->{module_specific}->{value}
	);

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

sub setAnalyzer {
	my ( $self, %params ) = @_;

	$self->{obj}->set( "alert.analyzer(0).name",         "Armadito antivirus" );
	$self->{obj}->set( "alert.analyzer(0).manufacturer", "www.teclib.com" );
	$self->{obj}->set( "alert.analyzer(0).class",        "Antivirus" );

	$self->{obj}->set( "alert.analyzer(0).process.name", $params{process_name} ) if $params{process_name};
	$self->{obj}->set( "alert.analyzer(0).process.pid",  $params{process_pid} )  if $params{process_pid};

	return $self;
}

sub setClassification {
	my ( $self, %params ) = @_;

	$self->{obj}->set( "alert.classification.text", $params{text} ) if $params{text};

	return $self;
}

sub setTarget {
	my ( $self, %params ) = @_;

	$self->{obj}->set( "alert.target(" . $params{i} . ").process.name",  $params{process_name} )  if $params{process_name};
	$self->{obj}->set( "alert.target(" . $params{i} . ").process.pid",   $params{process_pid} )   if $params{process_pid};
	$self->{obj}->set( "alert.target(" . $params{i} . ").user.category", $params{user_category} ) if $params{user_category};
	$self->{obj}->set( "alert.target(" . $params{i} . ").user.user_id(0).name", $params{user_id} )   if $params{user_id};
	$self->{obj}->set( "alert.target(" . $params{i} . ").node.name",            $params{node_name} ) if $params{node_name};
	$self->{obj}->set( "alert.target(" . $params{i} . ").node.address.category", $params{node_address_category} )
		if $params{node_address_category};
	$self->{obj}->set( "alert.target(" . $params{i} . ").node.address.address", $params{node_address} )
		if $params{node_address};

	return $self;
}

sub setAssessment {
	my ( $self, %params ) = @_;

	$self->{obj}->set( "alert.assessment.impact.severity",    $params{impact_severity} )    if $params{impact_severity};
	$self->{obj}->set( "alert.assessment.impact.type",        $params{impact_type} )        if $params{impact_type};
	$self->{obj}->set( "alert.assessment.impact.completion",  $params{impact_completion} )  if $params{impact_completion};
	$self->{obj}->set( "alert.assessment.impact.description", $params{impact_description} ) if $params{impact_description};

	return $self;
}

sub setAdditionalData {
	my ( $self, %params ) = @_;

	$self->{obj}->set( "alert.additional_data(" . $params{i} . ").type",    $params{type} )    if $params{type};
	$self->{obj}->set( "alert.additional_data(" . $params{i} . ").meaning", $params{meaning} ) if $params{meaning};
	$self->{obj}->set( "alert.additional_data(" . $params{i} . ").data",    $params{data} )    if $params{data};

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
