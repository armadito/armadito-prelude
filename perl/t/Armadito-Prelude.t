use strict;
use warnings;
use English qw(-no_match_vars);
use UNIVERSAL::require;
use Test::More tests => 1;

SKIP: {
	eval { Prelude->require(); };

	skip( 'compile tests need Prelude library', 1 )
		if $@;

	use_ok('Armadito::Prelude');
}
