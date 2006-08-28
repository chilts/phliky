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
my ($text, $html_exp, $html_got);

## ----------------------------------------------------------------------------
# centered

$text = "^ a quote";
$html_exp = "<p style=\"text-align: center;\">a quote</p>\n";
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, 'centered');

## ----------------------------------------------------------------------------
# html

$text = "< &copy; 2006 <b>Andrew Chilton</b>";
$html_exp = "&copy; 2006 <b>Andrew Chilton</b>\n";
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, 'html text');

## ----------------------------------------------------------------------------
# an unordered list

$text = "* a list\n# some more";
$html_exp = "<ul>\n  <li>a list</li>\n  <li>some more</li>\n</ul>\n";
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, 'unordered list');

## ----------------------------------------------------------------------------
# an ordered list

$text = "# a list\n# another one";
$html_exp = "<ol>\n  <li>a list</li>\n  <li>another one</li>\n</ol>\n";
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, 'ordered list');

## ----------------------------------------------------------------------------
