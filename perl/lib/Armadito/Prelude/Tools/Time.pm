package Armadito::Prelude::Tools::Time;

use strict;
use warnings;
use base 'Exporter';
use English qw(-no_match_vars);

our @EXPORT_OK = qw(
	FormatTimestamp
);

sub FormatTimestamp {
	my ($timestamp) = @_;
	my ( $sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst ) = localtime($timestamp);
	return sprintf( "%04d-%02d-%02d %02d:%02d:%02d", $year + 1900, $mon + 1, $mday, $hour, $min, $sec );
}

1;
__END__

=head1 NAME

Armadito::Prelude::Tools::Time - Tools for timestamp manipulation

=head1 DESCRIPTION

This module provides some functions for easy time conversions.

=head1 FUNCTIONS

=head2 FormatTimestamp($timestamp)

Format given UNIX timestamp to format %Y-%m-%d %H:%M:%S.
