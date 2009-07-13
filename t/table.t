#!/usr/bin/perl
## ----------------------------------------------------------------------------

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
my ($text, $html_exp, $html_got, $name);

## ----------------------------------------------------------------------------
# simple table

$name = 'a simple table 1';
$text = <<'EOF';
[ Drink | Cups Per Day
EOF
$html_exp = << 'EOF';
<table>
  <thead>
    <tr>
      <th>Drink</th>
      <th>Cups Per Day</th>
    </tr>
  </thead>
</table>
EOF
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, $name);

## ----------------------------------------------------------------------------
# a less simple table

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
