#!/usr/bin/perl
## -------------------------------------------------------------------*-perl-*-

use strict;
use warnings;

use Test::More;
use Data::Dumper;

use Text::Phliky;

## ----------------------------------------------------------------------------

plan tests => 1;

## ----------------------------------------------------------------------------
# create the object and some variables

my $phliky = Text::Phliky->new();
my ($text, $html_exp, $html_got);

## ----------------------------------------------------------------------------
# unknown

$text =<<'EOF';
A \z{something}.
EOF

$html_exp =<<'EOF';
<p>A \[z]{something}.</p>
EOF

$html_got = $phliky->text2html( $text );

is($html_got, $html_exp, 'a something');

## ----------------------------------------------------------------------------
