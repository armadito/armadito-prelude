package Armadito::Prelude;

use 5.008000;
use strict;
use warnings;
use English qw(-no_match_vars);
use UNIVERSAL::require;

require Exporter;

use Armadito::Prelude::IDMEF;
use Armadito::Prelude::Client;
use Armadito::Prelude::XML::Parser;
use Armadito::Prelude::Tools::Dir qw(readDirectory);
use Armadito::Prelude::Tools::File qw(readFile);
use Armadito::Prelude::HTTP::Client::ArmaditoAV;

our $VERSION      = "0.0.4_01";
our $AGENT_STRING = "Armadito-Prelude_v" . $VERSION;

sub new {
	my ( $class, %params ) = @_;

	my $self = {
		status  => 'unknown',
		confdir => $params{confdir},
		datadir => $params{datadir},
		libdir  => $params{libdir},
		vardir  => $params{vardir},
		sigterm => $params{sigterm}
	};
	bless $self, $class;

	return $self;
}

sub init {
	my ( $self, %params ) = @_;

	$self->{prelude_client} = Armadito::Prelude::Client->new( name => "armadito-prelude" );
	$self->{inputdir}  = $params{options}->{input}              ? $params{options}->{input}  : "";
	$self->{maxalerts} = $params{options}->{max}                ? $params{options}->{max}    : -1;
	$self->{"no-rm"}   = defined( $params{options}->{"no-rm"} ) ? 1                          : 0;
	$self->{action}    = $params{options}->{action}             ? $params{options}->{action} : "";
	$self->{scanpath}  = $params{options}->{path}               ? $params{options}->{path}   : "";

	return $self;
}

sub _processAlert {
	my ( $self, %params ) = @_;

	my $filecontent = readFile( filepath => $params{filepath} );
	my $parser = Armadito::Prelude::XML::Parser->new( text => $filecontent );
	$parser->run();

	eval {
		my $idmef = Armadito::Prelude::IDMEF->new();
		$idmef->setFromXML( xml => $parser->{xmlparsed} );
		$self->{prelude_client}->{client}->sendIDMEF( $idmef->{obj} );
	};

	if ($EVAL_ERROR) {
		warn $EVAL_ERROR;
		return 1;
	}

	unlink $params{filepath} if ( !$self->{"no-rm"} );
	return 0;
}

sub _processAlertDir {
	my ( $self, %params ) = @_;
	my @alerts = readDirectory( dirpath => $self->{inputdir} );

	my $i      = 0;
	my $errors = 0;

	foreach my $alert (@alerts) {
		$errors += $self->_processAlert( filepath => $self->{inputdir} . "/" . $alert );
		$i++;
		last if ( $i - $errors >= $self->{maxalerts} && $self->{maxalerts} >= 0 );
	}

	print "$i alerts processed, $errors errors.\n";
	return $self;
}

sub _getAVStatus {
	my ( $self, %params ) = @_;

	$self->{av_client} = Armadito::Prelude::HTTP::Client::ArmaditoAV->new( prelude_client => $self->{prelude_client} );
	$self->{av_client}->register();

	my $response = $self->{av_client}->sendRequest(
		"url"  => $self->{av_client}->{server_url} . "/api/status",
		method => "GET"
	);

	die "Unable to get AV status with ArmaditoAV api."
		if ( !$response->is_success() );

	$self->{av_client}->pollEvents();
	$self->{av_client}->unregister();
	return $self;
}

sub _getScanAPIMessage {
	my ($self) = @_;
	return "{ 'path' : '" . $self->{scanpath} . "' }";
}

sub _onDemandScan {
	my ( $self, %params ) = @_;

	$self->{av_client} = Armadito::Prelude::HTTP::Client::ArmaditoAV->new( prelude_client => $self->{prelude_client} );
	$self->{av_client}->register();

	my $response = $self->{av_client}->sendRequest(
		"url"   => $self->{av_client}->{server_url} . "/api/scan",
		message => $self->_getScanAPIMessage(),
		method  => "POST"
	);

	die "ArmaditoAV Scan request failed." if ( !$response->is_success() );

	$self->{av_client}->pollEvents();
	$self->{av_client}->unregister();
	return $self;
}

sub run {
	my ( $self, %params ) = @_;

	$self->{prelude_client}->start();

	if ( $self->{inputdir} ne "" ) {
		$self->_processAlertDir();
	}
	elsif ( $self->{action} eq "status" ) {
		$self->_getAVStatus();
	}
	elsif ( $self->{action} eq "scan" ) {
		die "You must specify a path to be scanned when using scan action." if ( $self->{scanpath} =~ /^\s*$/ );
		$self->_onDemandScan();
	}

	return $self;
}

1;
__END__

=head1 NAME

Armadito::Prelude - Armadito-Prelude communication client in Perl language.

=head1 DESCRIPTION

Armadito-Prelude is a tool essentially developed to send Armadito Antivirus' virus alerts to Prelude SIEM.

Note : If an alert is successfully processed, it is automatically removed from disk. You can modify this behavior by using option --no-rm.

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

Copyright (C) 2006-2010 OCS Inventory contributors
Copyright (C) 2010-2012 FusionInventory Team
Copyright (C) 2016 by Teclib'

Licensed under GPLv3+.

=cut
