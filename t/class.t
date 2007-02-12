#!/usr/bin/perl
## -------------------------------------------------------------------*-perl-*-

use strict;
use warnings;

use Test::More;
use Data::Dumper;

use Text::Phliky;

## ----------------------------------------------------------------------------

plan tests => 1;

## ----------------------------------------------------------------------------
# class functions

is( Text::Phliky->uri("? &"), "%3F%20%26", 'uri');

## ----------------------------------------------------------------------------
