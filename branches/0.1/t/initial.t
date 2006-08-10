#!/usr/bin/perl
## -------------------------------------------------------------------*-perl-*-

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
my ($text, $html_exp, $html_got);

## ----------------------------------------------------------------------------
# simple

$text =<<'EOF';
This is a paragraph.
EOF

$html_exp =<<'EOF';
<p>This is a paragraph.</p>
EOF

$html_got = $phliky->text2html( $text );

is($html_got, $html_exp, 'simple paragraph');

## ----------------------------------------------------------------------------
# simple2

$text =<<'EOF';
This is paragraph 1.

This is paragraph 2.
EOF

$html_exp =<<'EOF';
<p>This is paragraph 1.</p>
<p>This is paragraph 2.</p>
EOF

$html_got = $phliky->text2html( $text );

is($html_got, $html_exp, 'simple paragraph 2');

## ----------------------------------------------------------------------------
