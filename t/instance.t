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
# instance methods

$text =<<'EOF';
A \l{link|http://news.bbc.co.uk/}.
EOF

$html_exp =<<'EOF';
<p>A <a href="http://news.bbc.co.uk/">link</a>.</p>
EOF

$phliky->text( $text );
$html_got = $phliky->html();

is($html_got, $html_exp, 'a link');

## ----------------------------------------------------------------------------
