#!/usr/bin/perl
## -------------------------------------------------------------------*-perl-*-

use strict;
use warnings;

use Test::More;
use Data::Dumper;

use Text::Phliky;

## ----------------------------------------------------------------------------

plan tests => 2;

## ----------------------------------------------------------------------------
# create the object and some variables

my $phliky = Text::Phliky->new();
my ($text, $html_exp, $html_got);

## ----------------------------------------------------------------------------
# simple heading

$text = "!1 A Heading\n";
$html_exp = "<h1>A Heading</h1>\n";
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, 'heading one');

## ----------------------------------------------------------------------------
# simple heading

$text = "!1{a-heading} A Heading\n";
$html_exp = "<a name=\"a-heading\"> </a>\n<h1>A Heading</h1>\n";
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, 'heading one with name');

## ----------------------------------------------------------------------------
