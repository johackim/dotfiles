#!/bin/bash

cd /tmp/
wget http://search.cpan.org/CPAN/authors/id/K/KI/KING/Clipboard-0.13.tar.gz
tar xvf Clipboard-0.13.tar.gz
cd Clipboard-0.13/
perl Makefile.PL && make all test && sudo make install

cd /tmp
wget http://search.cpan.org/CPAN/authors/id/D/DA/DAGOLDEN/Capture-Tiny-0.40.tar.gz
tar xvf Capture-Tiny-0.40.tar.gz
cd Capture-Tiny-0.40/
perl Makefile.PL && make all test && sudo make install
