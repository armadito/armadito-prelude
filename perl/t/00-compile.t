use strict;
use warnings;
use Test::More;
use Test::Compile;
use English qw(-no_match_vars);
use UNIVERSAL::require;
use Module::Runtime qw(use_module);

SKIP: {
	my $prelude = use_module("Prelude");

	skip( 'compile tests need Prelude library', 1 )
		if !$prelude;

	my @scripts = qw(mod2html podtree2html pods2html perl2html);
	my $test    = Test::Compile->new();
	$test->all_files_ok();
	$test->pl_file_compiles($_) for @scripts;
	$test->done_testing();
}
1;
