#!/usr/bin/perl
## -------------------------------------------------------------------*-perl-*-

use strict;
use warnings;

use Test::More;
use Data::Dumper;

use Text::Phliky;

## ----------------------------------------------------------------------------

plan tests => 6;

## ----------------------------------------------------------------------------
# create the object and some variables

my $phliky = Text::Phliky->new();
my ($text, $html_exp, $html_got, $name);

## ----------------------------------------------------------------------------
# centered

$text = "^ a centered";
$html_exp = "<p style=\"text-align: center;\">a centered</p>\n";
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, 'centered');

## ----------------------------------------------------------------------------
# html

$text = "< &copy; 2006 <b>Andrew Chilton</b>";
$html_exp = "&copy; 2006 <b>Andrew Chilton</b>\n";
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, 'html text');

## ----------------------------------------------------------------------------
# quote

$text = '" a blockquote';
$html_exp = "<blockquote>a blockquote</blockquote>\n";
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, 'blockquote');

$text = '" "a blockquote"';
$html_exp = "<blockquote>&quot;a blockquote&quot;</blockquote>\n";
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, 'blockquote 2');

## ----------------------------------------------------------------------------
# blank paragraph

$name = 'a blank paragraph';
$text = '';
$html_exp = '';
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, $name);

## ----------------------------------------------------------------------------

$name = 'horizontal rule';
$text = '- a horizontal rule';
$html_exp = "<hr />\n";
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, $name);

## ----------------------------------------------------------------------------
