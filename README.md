# Sys::Lastlog

Get access to the last login information on Unix-like systems

[![Build Status](https://travis-ci.org/jonathanstowe/Raku-Sys-Lastlog.svg?branch=master)](https://travis-ci.org/jonathanstowe/Raku-Sys-Lastlog)

## Description

This module is designed to provided an Object Oriented API to the lastlog
file found on many Unix-like systems.  Some systems do not have this file
so this module will not be of much use on those systems.


## Installation

Currently there is no dedicated test to determine whether your platform is
supported, the unit tests will simply fail horribly.

It is known not to work on Windows, MacOS and Alpine Linux so will
abort the installation without tring on those platforms.

Assuming you have a working Rakudo installation you should be able to
install this with *zef* :

    # From the source directory

    zef install .

    # Remote installation

    zef install Sys::Lastlog

## Support

Suggestions/patches are welcomed via github at https://github.com/jonathanstowe/Raku-Sys-Lastlog/issues

## Copyright and Licence

This is free software, please see the [LICENCE](LICENCE) file.

© Jonathan Stowe 2015-2020
