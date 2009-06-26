#!/usr/bin/perl
## -------------------------------------------------------------------*-perl-*-

use strict;
use warnings;

use Test::More;
use Data::Dumper;

use Text::Phliky;

## ----------------------------------------------------------------------------

plan tests => 7;

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

$name = 'a less simple table';
$text = <<'EOF';
[ Drink | Cups Per Day
] Totals | 6
- Orange | 1
- Coffee | 2
- Tea | 3
EOF
$html_exp = << 'EOF';
<table>
  <thead>
    <tr>
      <th>Drink</th>
      <th>Cups Per Day</th>
    </tr>
  </thead>
  <tfoot>
    <tr>
      <td>Totals</td>
      <td>6</td>
    </tr>
  </tfoot>
  <tbody>
    <tr>
      <td>Orange</td>
      <td>1</td>
    </tr>
    <tr>
      <td>Coffee</td>
      <td>2</td>
    </tr>
    <tr>
      <td>Tea</td>
      <td>3</td>
    </tr>
  </tbody>
</table>
EOF
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, $name);

## ----------------------------------------------------------------------------

$name = 'horizontal rule';
$text = '- a horizontal rule';
$html_exp = "<hr />\n";
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, $name);

## ----------------------------------------------------------------------------
