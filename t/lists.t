#!/usr/bin/perl
## -------------------------------------------------------------------*-perl-*-

use strict;
use warnings;

use Test::More;
use Data::Dumper;

use Text::Phliky;

## ----------------------------------------------------------------------------

plan tests => 11;

## ----------------------------------------------------------------------------
# create the object and some variables

my $phliky = Text::Phliky->new();
my ($text, $html_exp, $html_got, $name);

## ----------------------------------------------------------------------------
# one item unordered list

$name = 'A small list';
$text = "* a list";
$html_exp = "<ul><li>a list</li></ul>";
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, $name);

## ----------------------------------------------------------------------------
# an unordered list

$name = 'a small nested list';
$text = "* list\n** sub-list";
$html_exp = "<ul><li>list<ul><li>sub-list</li></ul></li></ul>";
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, $name);

## ----------------------------------------------------------------------------
# an unordered list

$text = "* a list\n* some more";
$html_exp = "<ul><li>a list</li><li>some more</li></ul>";
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, 'unordered list');

## ----------------------------------------------------------------------------
# one item ordered list

$name = 'an ordered list';
$text = "# a list";
$html_exp = "<ol><li>a list</li></ol>";
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, $name);

## ----------------------------------------------------------------------------
# small ordered list

$name = 'an ordered list';
$text = "# a list\n# another one";
$html_exp = "<ol><li>a list</li><li>another one</li></ol>";
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, $name);

## ----------------------------------------------------------------------------

$name = 'a simple nested list';
$text = <<'EOF';
# one
** a
** b
EOF
$html_exp = "<ol><li>one<ul><li>a</li><li>b</li></ul></li></ol>";
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, $name);

## ----------------------------------------------------------------------------

$name = 'a middle nested list';
$text = <<'EOF';
# one
** a
# two
EOF
$html_exp = "<ol><li>one<ul><li>a</li></ul></li><li>two</li></ol>";
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, $name);

## ----------------------------------------------------------------------------

$name = 'a complex nested list';
$text = <<'EOF';
# one
# two
** 2a
** 2b
# three
EOF
$html_exp = "<ol><li>one</li><li>two<ul><li>2a</li><li>2b</li></ul></li><li>three</li></ol>";
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, $name);

## ----------------------------------------------------------------------------

$name = 'a thick-bottom list';
$text = <<'EOF';
# 1
## 1.1
### 1.1.1
EOF
$html_exp = "<ol><li>1<ol><li>1.1<ol><li>1.1.1</li></ol></li></ol></li></ol>";
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, $name);

## ----------------------------------------------------------------------------

$name = 'a quickly-nested list';
$text = <<'EOF';
# 1
### 1.1.1
EOF
$html_exp = "<ol><li>1<ol><li><ol><li>1.1.1</li></ol></li></ol></li></ol>";
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, $name);

## ----------------------------------------------------------------------------

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
