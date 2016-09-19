package Armadito::Prelude::HTTP::Client::ArmaditoAV::Event::OnDemandCompletedEvent;

use strict;
use warnings;
use base 'Armadito::Prelude::HTTP::Client::ArmaditoAV::Event';

use JSON;
use Armadito::Prelude::Tools::Security qw(isANumber);

sub new {
	my ( $class, %params ) = @_;

	my $self = $class->SUPER::new(%params);

	# TODO: Add more validation
	die "Invalid total_malware_count."    if !isANumber( $self->{jobj}->{total_malware_count} );
	die "Invalid total_suspicious_count." if !isANumber( $self->{jobj}->{total_suspicious_count} );
	die "Invalid total_scanned_count."    if !isANumber( $self->{jobj}->{total_scanned_count} );

	$self->{jobj}->{malware_count}    = $self->{jobj}->{total_malware_count};
	$self->{jobj}->{suspicious_count} = $self->{jobj}->{total_suspicious_count};
	$self->{jobj}->{scanned_count}    = $self->{jobj}->{total_scanned_count};

	delete $self->{jobj}->{total_malware_count};
	delete $self->{jobj}->{total_suspicious_count};
	delete $self->{jobj}->{total_scanned_count};

	$self->{jobj}->{progress} = 100;

	return $self;
}

sub run {
	my ( $self, %params ) = @_;

	$self->{end_polling} = 1;

	return $self;
}
1;

__END__

=head1 NAME

Armadito::Prelude::HTTP::Client::ArmaditoAV::Event::OnDemandCompletedEvent - ArmaditoAV OnDemandCompletedEvent class

=head1 DESCRIPTION

This is the class dedicated to OnDemandCompletedEvent of ArmaditoAV api.

=head1 FUNCTIONS

=head2 run ( $self, %params )

Run event related stuff.

=head2 new ( $class, %params )

Instanciate this class.

