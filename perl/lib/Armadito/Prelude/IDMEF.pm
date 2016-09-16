package Armadito::Prelude::IDMEF;

use strict;
use warnings;
use English qw(-no_match_vars);
use UNIVERSAL::require;
use Prelude;

require Exporter;

#from https://www.prelude-siem.org/projects/prelude-lml-rules/repository/revisions/master/entry/ruleset/clamav.rules
# classification.text=Virus found: $2; \
# id=3200; \
# revision=2; \
# analyzer(0).name=Clam Antivirus; \
# analyzer(0).manufacturer=www.clamav.net; \
# analyzer(0).class=Antivirus; \
# assessment.impact.severity=high; \
# assessment.impact.type=file; \
# assessment.impact.completion=succeeded; \
# assessment.impact.description=A virus has been identified by ClamAV; \
# additional_data(0).type=string; \
# additional_data(0).meaning=File location; \
# additional_data(0).data=$1; \
# additional_data(1).type=string; \
# additional_data(1).meaning=Malware name; \
# additional_data(1).data=$1; \

sub new {
	my ( $class, %params ) = @_;

	my $self = {};

	# Source
	#$self->{obj}->set("alert.source(0).node.address(0).address", "127.0.0.1");

	$self->{obj} = Prelude::IDMEF->new();

	bless $self, $class;
	return $self;
}

# See RFC 4765.
sub setFromXML {
	my ( $self, %params ) = @_;

	$self->_setAnalyzer($xml);
	$self->_setClassification($xml);
	$self->_setTarget($xml);
	$self->_setAssessment($xml);
	$self->_setAdditionalData($xml);

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

	$self->{obj}->set( "alert.analyzer(0).name",         "Armadito antivirus");
	$self->{obj}->set( "alert.analyzer(0).manufacturer", "www.teclib.com");
	$self->{obj}->set( "alert.analyzer(0).class",        "Antivirus");
	$self->{obj}->set( "alert.analyzer(0).process.name", $xml->{alert}->{identification}->{process}->{value});
	$self->{obj}->set( "alert.analyzer(0).process.pid",  $xml->{alert}->{identification}->{pid}->{value});

	return $self;
}

sub _setClassification {
	my ( $self, $xml ) = @_;

	$self->{obj}->set( "alert.classification.text", "Virus found: " . $xml->{alert}->{module_specific}->{value});

	return $self;
}

sub _setTarget {
	my ( $self, $xml ) = @_;

	$self->{obj}->set( "alert.target(0).process.name",  $xml->{alert}->{identification}->{process}->{value});
	$self->{obj}->set( "alert.target(0).process.pid",   $xml->{alert}->{identification}->{pid}->{value});
	$self->{obj}->set( "alert.target(0).user.category", "application");
	$self->{obj}->set( "alert.target(0).user.user_id(0).name", $xml->{alert}->{identification}->{user}->{value});
	$self->{obj}->set( "alert.target(0).node.name", $xml->{alert}->{identification}->{hostname}->{value});
	$self->{obj}->set( "alert.target(0).node.address.category", "ipv4-addr");
	$self->{obj}->set( "alert.target(0).node.address.address", $xml->{alert}->{identification}->{ip}->{value});

	return $self;
}

sub _setAssessment{
	my ( $self, $xml ) = @_;

	$self->{obj}->set( "alert.assessment.impact.severity", $self->_getLevelStr($xml->{alert}->{level}->{value}));
	$self->{obj}->set( "alert.assessment.impact.type",       "file");
	$self->{obj}->set( "alert.assessment.impact.completion", "succeeded");
	$self->{obj}->set( "alert.assessment.impact.description", "Virus detected by Armadito AV on-access protection");

	return $self;
}


sub _setAdditionalData {
	my ( $self, $xml ) = @_;

	$self->{obj}->set( "alert.additional_data(0).type",    "string");
	$self->{obj}->set( "alert.additional_data(0).meaning", "File location");
	$self->{obj}->set( "alert.additional_data(0).data",    $xml->{alert}->{uri}->{value});

	$self->{obj}->set( "alert.additional_data(1).type",    "string");
	$self->{obj}->set( "alert.additional_data(1).meaning", "Virus name");
	$self->{obj}->set( "alert.additional_data(1).data",    $xml->{alert}->{module_specific}->{value});

	return $self;
}
1;

