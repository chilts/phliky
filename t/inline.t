#!/usr/bin/perl
## -------------------------------------------------------------------*-perl-*-

use strict;
use warnings;

use Test::More;
use Data::Dumper;

use Text::Phliky;

## ----------------------------------------------------------------------------

plan tests => 12;

## ----------------------------------------------------------------------------
# create the object and some variables

my $phliky = Text::Phliky->new();
my ($text, $html_exp, $html_got);

## ----------------------------------------------------------------------------
# bold

$text = "To \\b{bold}.";
$html_exp = "<p>To <strong>bold</strong>.</p>\n";
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, 'bold');

## ----------------------------------------------------------------------------
# em

$text = "To \\i{emphasize}.";
$html_exp = "<p>To <em>emphasize</em>.</p>\n";
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, 'emphasis');

## ----------------------------------------------------------------------------
# underline

$text = "To \\u{underline}.";
$html_exp = "<p>To <span style=\"text-decoration: underline;\">underline</span>.</p>\n";
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, 'emphasis');

## ----------------------------------------------------------------------------
# code

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
# image

$text = "Image \\img{one|one.jpg} and image \\img{two|two.jpg}.";
$html_exp = '<p>Image <img src="one.jpg" title="one" /> and image <img src="two.jpg" title="two" />.</p>' . "\n";
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, 'img x 2');

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
# br

$text = "Line One\\br{Horizontal Rule}Line Two";
$html_exp = "<p>Line One<br />Line Two</p>\n";
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, 'br');

## ----------------------------------------------------------------------------
# br2

$text = "Line One\\br{}Line Two";
$html_exp = "<p>Line One<br />Line Two</p>\n";
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, 'br2');

## ----------------------------------------------------------------------------
# h

$text = "A link \\h{http://www.kiwiwriters.org/} here";
$html_exp = "<p>A link <a href=\"http://www.kiwiwriters.org/\">http://www.kiwiwriters.org/</a> here</p>\n";
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, 'h');

## ----------------------------------------------------------------------------
# w

$text = "A wiki-link \\w{here}";
$html_exp = "<p>A wiki-link <a href=\"here.html\">here</a></p>\n";
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, 'wiki-link');

## ----------------------------------------------------------------------------
