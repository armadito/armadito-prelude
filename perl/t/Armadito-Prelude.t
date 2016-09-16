use strict;
use warnings;

use Test::More tests => 1;
use Module::Runtime qw(use_module);

SKIP: {
	my $prelude = use_module("Prelude");

	skip( 'compile tests need Prelude library', 1 )
		if !$prelude;

	use_ok('Armadito::Prelude');
}
