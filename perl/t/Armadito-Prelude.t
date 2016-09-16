use strict;
use warnings;

use Test::More tests => 1;

SKIP: {
	eval {
		use Prelude;
	};

	skip( 'compile tests need Prelude library', 1 )
		if $@;

	use_ok('Armadito::Prelude');
}
