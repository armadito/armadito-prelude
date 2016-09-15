#!/bin/bash

#set -e

PRELUDE_PREFIX=~/prelude/install/

tidyall -a
perl Makefile.PL PREFIX=$PRELUDE_PREFIX
make
LD_LIBRARY_PATH=$PRELUDE_PREFIX/lib PERL5LIB=$PRELUDE_PREFIX/lib/x86_64-linux-gnu/perl/5.22.1/ make test
make install
