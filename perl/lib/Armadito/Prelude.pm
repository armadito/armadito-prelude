package Armadito::Prelude;

use 5.008000;
use strict;
use warnings;
use English qw(-no_match_vars);
use UNIVERSAL::require;
use Prelude;

require Exporter;

our $VERSION = "0.0.2";

sub new {
	my ( $class, %params ) = @_;

	my $self = {
		status  => 'unknown',
		confdir => $params{confdir},
		datadir => $params{datadir},
		libdir  => $params{libdir},
		vardir  => $params{vardir},
		sigterm => $params{sigterm},
		targets => [],
		tasks   => []
	};
	bless $self, $class;

	return $self;
}

sub init {
	my ( $self, %params ) = @_;

	return $self;
}

sub run {

	# Create a new Prelude client.
	my $client = new Prelude::ClientEasy("armadito-prelude");
	$client->start();

	# Create an IDMEF message
	my $idmef = new Prelude::IDMEF();

	# Classification
	$idmef->set( "alert.classification.text",               "Perl Example" );
	$idmef->set( "alert.source(0).node.address(0).address", "10.0.0.1" );
	$idmef->set( "alert.target(0).node.address(0).address", "10.0.0.2" );
	$idmef->set( "alert.target(1).node.address(0).address", "10.0.0.3" );

	# Assessment
	$idmef->set( "alert.assessment.impact.severity",   "low" );
	$idmef->set( "alert.assessment.impact.completion", "failed" );
	$idmef->set( "alert.assessment.impact.type",       "recon" );

	# Additional Data
	$idmef->set( "alert.additional_data(0).data", "something" );

	# Send the generated message
	$client->sendIDMEF($idmef);

	print "Prelude OK!";
	return;
}

1;
__END__

=head1 NAME

Armadito::Prelude - Armadito-Prelude communication client in Perl language.

=head1 DESCRIPTION

Armadito-Prelude is a tool essentially developed to send Armadito Antivirus' virus alerts to Prelude SIEM.

=head1 METHODS

=head2 new(%params)

The constructor. The following parameters are allowed, as keys of the %params
hash:

=over

=item I<confdir>

the configuration directory.

=item I<datadir>

the read-only data directory.

=item I<vardir>

the read-write data directory.

=item I<options>

the options to use.

=back

=head2 init()

Initialize the agent.

=back

=head1 SEE ALSO

Armadito AV documentation : L<http://armadito-av.readthedocs.io/en/latest/>

Prelude Website : L<https://www.prelude-siem.org/>

=head1 AUTHOR

vhamon, E<lt>vhamon@teclib.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2016 by Teclib'

=cut
