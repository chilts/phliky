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
my ($text, $html_exp, $html_got);

## ----------------------------------------------------------------------------
# bold

$text = "To \\b{bold}.";
$html_exp = "<p>To <b>bold</b>.</p>\n";
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, 'bold');

## ----------------------------------------------------------------------------
# em

$text = "To \\i{emphasize}.";
$html_exp = "<p>To <em>emphasize</em>.</p>\n";
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, 'emphasis');

## ----------------------------------------------------------------------------
# bold

$text = "To \\c{code}.";
$html_exp = "<p>To <code>code</code>.</p>\n";
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, 'code');

## ----------------------------------------------------------------------------
# image

$text = "Sunset at \\img{Kapiti|http://photos.chilts.org/s/m/2e88cad09e3ad52acf8d5bbfcefd8834.jpg}.";
$html_exp = "<p>Sunset at <img src=\"http://photos.chilts.org/s/m/2e88cad09e3ad52acf8d5bbfcefd8834.jpg\" title=\"Kapiti\" />.</p>\n";
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, 'img');

## ----------------------------------------------------------------------------
# abbreviation

$text = "This is an \\a{Abbr|Abbreviation} for Phliky";
$html_exp = "<p>This is an <acronym title=\"Abbreviation\">Abbr</acronym> for Phliky</p>\n";
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, 'abbreviation');

## ----------------------------------------------------------------------------
# abbreviation 2

$text = "\\a{<*OMG*>|<Oh My God>}";
$html_exp = "<p><acronym title=\"&lt;Oh My God&gt;\">&lt;*OMG*&gt;</acronym></p>\n";
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, 'abbreviation 2');

## ----------------------------------------------------------------------------
