#!/usr/bin/perl
## -------------------------------------------------------------------*-perl-*-

use strict;
use warnings;

use Test::More;
use Data::Dumper;

use Text::Phliky;

## ----------------------------------------------------------------------------

plan tests => 4;

## ----------------------------------------------------------------------------
# create the object and some variables

my $phliky = Text::Phliky->new();
my ($text, $html_exp, $html_got, $name);

## ----------------------------------------------------------------------------
# paragraph with a class

$text = "~{small} a quote";
$html_exp = "<p class=\"small\">a quote</p>\n";
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, 'small');

## ----------------------------------------------------------------------------

$text = "~{c} a quote";
$html_exp = "<p class=\"c\">a quote</p>\n";
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, 'c');

## ----------------------------------------------------------------------------

$text = "~{two classes} a quote";
$html_exp = "<p>~{two classes} a quote</p>\n";
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, 'c');

## ----------------------------------------------------------------------------

$text = "~{} a quote";
$html_exp = "<p>~{} a quote</p>\n";
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, 'failure (normal paragraph)');

## ----------------------------------------------------------------------------
