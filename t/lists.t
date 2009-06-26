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
$html_exp = "<ul>\n<li>a list</li>\n</ul>\n";
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, $name);

## ----------------------------------------------------------------------------
# an unordered list

$name = 'a small nested list';
$text = "* list\n** sub-list";
$html_exp = "<ul>\n<li>list\n<ul>\n<li>sub-list</li>\n</ul>\n</li>\n</ul>\n";
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, $name);

## ----------------------------------------------------------------------------
# an unordered list

$text = "* a list\n* some more";
$html_exp = "<ul>\n<li>a list</li>\n<li>some more</li>\n</ul>\n";
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, 'unordered list');

## ----------------------------------------------------------------------------
# one item ordered list

$name = 'an ordered list';
$text = "# a list";
$html_exp = "<ol>\n<li>a list</li>\n</ol>\n";
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, $name);

## ----------------------------------------------------------------------------
# small ordered list

$name = 'an ordered list';
$text = "# a list\n# another one";
$html_exp = "<ol>\n<li>a list</li>\n<li>another one</li>\n</ol>\n";
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, $name);

## ----------------------------------------------------------------------------

$name = 'a simple nested list';
$text = <<'EOF';
# one
** a
** b
EOF
$html_exp = "<ol>\n<li>one\n<ul>\n<li>a</li>\n<li>b</li>\n</ul>\n</li>\n</ol>\n";
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, $name);

## ----------------------------------------------------------------------------

$name = 'a middle nested list';
$text = <<'EOF';
# one
** a
# two
EOF
$html_exp = "<ol>\n<li>one\n<ul>\n<li>a</li>\n</ul>\n</li>\n<li>two</li>\n</ol>\n";
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
$html_exp = "<ol>\n<li>one</li>\n<li>two\n<ul>\n<li>2a</li>\n<li>2b</li>\n</ul>\n</li>\n<li>three</li>\n</ol>\n";
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, $name);

## ----------------------------------------------------------------------------

$name = 'a thick-bottom list';
$text = <<'EOF';
# 1
## 1.1
### 1.1.1
EOF
$html_exp = "<ol>\n<li>1\n<ol>\n<li>1.1\n<ol>\n<li>1.1.1</li>\n</ol>\n</li>\n</ol>\n</li>\n</ol>\n";
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, $name);

## ----------------------------------------------------------------------------

$name = 'a quickly-nested list';
$text = <<'EOF';
# 1
### 1.1.1
EOF
$html_exp = "<ol>\n<li>1\n<ol>\n<li>\n<ol>\n<li>1.1.1</li>\n</ol>\n</li>\n</ol>\n</li>\n</ol>\n";
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
