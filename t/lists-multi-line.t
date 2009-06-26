#!/usr/bin/perl
## ----------------------------------------------------------------------------

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
# one item unordered list

$name = 'A small list';
$text = "* a list\nspread over two lines";
$html_exp = "\n<ul>\n<li>a list spread over two lines</li>\n</ul>\n";
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, $name);

## ----------------------------------------------------------------------------
# some unordered items

$name = 'A small list';
$text = "* a list\nwith extra lines\n* another\npoint\n* some\nmore\nlines";
$html_exp = "\n<ul>\n<li>a list with extra lines</li>\n<li>another point</li>\n<li>some more lines</li>\n</ul>\n";
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, $name);

## ----------------------------------------------------------------------------
# some unordered items (with spaces at the start)

$name = 'A small list';
$text = "* a list\n  with extra lines\n* another\n  point\n* some\n  more\n  lines";
$html_exp = "\n<ul>\n<li>a list with extra lines</li>\n<li>another point</li>\n<li>some more lines</li>\n</ul>\n";
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, $name);

## ----------------------------------------------------------------------------
# some multi level lists

$name = 'A small list';
$text = "* a list\nwith extra lines\n** another\npoint\n* some\nmore\nlines";
$html_exp = "\n<ul>\n<li>a list with extra lines\n<ul>\n<li>another point</li>\n</ul>\n</li>\n<li>some more lines</li>\n</ul>\n";
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, $name);

## ----------------------------------------------------------------------------
