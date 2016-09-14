#!/bin/sh

set -e

tidyall -a
perl Makefile.PL PREFIX=~/prelude/install/
make
#make test
sudo make install
