#!perl6

use v6;

use LibraryMake;
use Shell::Command;

my $destdir = '../lib';
my %vars = get-vars($destdir);
mkpath "lib/../resources/lib";
process-makefile('src', %vars);
make('src', $destdir);
