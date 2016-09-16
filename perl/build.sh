#!/bin/bash

# Build script For travis-ci
cd perl/
perl Makefile.PL
make
make test
make install
