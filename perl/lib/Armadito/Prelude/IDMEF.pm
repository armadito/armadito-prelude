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

	$self->{obj} = new Prelude::IDMEF();

	# analyzer
	$self->{obj}->set( "alert.analyzer(0).name",         "Armadito antivirus" );
	$self->{obj}->set( "alert.analyzer(0).manufacturer", "www.teclib.com" );
	$self->{obj}->set( "alert.analyzer(0).class",        "Antivirus" );

	bless $self, $class;
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

## RFC 4765 extract :
#   <!ENTITY % attvals.severity             "
#       ( info | low | medium | high )
#     ">
#   <!ENTITY % attvals.completion           "
#       ( failed | succeeded )
#     ">
#   <!ENTITY % attvals.impacttype           "
#       ( admin | dos | file | recon | user | other )
#     ">

sub setFromXML {
	my ( $self, %params ) = @_;

	$self->{obj}->set( "alert.classification.text", "Threat detected" );

	# Assessment
	$self->{obj}
		->set( "alert.assessment.impact.severity", $self->_getLevelStr( $params{xml}->{alert}->{level}->{value} ) );
	$self->{obj}->set( "alert.assessment.impact.type",       "file" );
	$self->{obj}->set( "alert.assessment.impact.completion", "succeeded" );
	$self->{obj}
		->set( "alert.assessment.impact.description", "virus detected by Armadito antivirus on-access protection" );

	# Additional Data
	$self->{obj}->set( "alert.additional_data(0).type",    "string" );
	$self->{obj}->set( "alert.additional_data(0).meaning", "File location" );
	$self->{obj}->set( "alert.additional_data(0).data",    $params{xml}->{alert}->{uri}->{value} );

	$self->{obj}->set( "alert.additional_data(1).type",    "string" );
	$self->{obj}->set( "alert.additional_data(1).meaning", "Virus name" );
	$self->{obj}->set( "alert.additional_data(1).data",    $params{xml}->{alert}->{module_specific}->{value} );

	#	$params{xml}->{alert}->{code}->{value};
	#	$params{xml}->{alert}->{level}->{value};
	#	$params{xml}->{alert}->{uri}->{value};
	#	$params{xml}->{alert}->{gdh}->{value};
	#	$params{xml}->{alert}->{identification}->{user}->{value};
	#	$params{xml}->{alert}->{module}->{value};
	#	$params{xml}->{alert}->{module_specific}->{value};

	return $self;
}
1;

