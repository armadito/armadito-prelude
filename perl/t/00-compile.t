use strict;
use warnings;
use Test::Compile;
use English qw(-no_match_vars);
use UNIVERSAL::require;

my @scripts = qw(mod2html podtree2html pods2html perl2html);
my $test    = Test::Compile->new();
$test->all_files_ok();
$test->pl_file_compiles($_) for @scripts;
$test->done_testing();

1;
