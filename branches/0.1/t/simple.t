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
# link

$text =<<'EOF';
A \l{link|http://news.bbc.co.uk/}.
EOF

$html_exp =<<'EOF';
<p>A <a href="http://news.bbc.co.uk/">link</a>.</p>
EOF

$html_got = $phliky->text2html( $text );

is($html_got, $html_exp, 'a link');

## ----------------------------------------------------------------------------
# popup link

$text =<<'EOF';
A \p{popup|http://news.bbc.co.uk/}.
EOF

$html_exp =<<'EOF';
<p>A <a target="_new" href="http://news.bbc.co.uk/">popup</a>.</p>
EOF

$html_got = $phliky->text2html( $text );

is($html_got, $html_exp, 'a popup');

## ----------------------------------------------------------------------------
