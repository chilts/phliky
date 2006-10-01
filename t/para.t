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
my ($text, $html_exp, $html_got, $name);

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

$name = 'a blank paragraph';
$text = '';
$html_exp = '';
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, $name);

## ----------------------------------------------------------------------------

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
