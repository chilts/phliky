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

my $normal = Text::Phliky->new({ mode => 'normal' });
my $basic = Text::Phliky->new({ mode => 'basic' });
my ($text, $html_exp, $html_got);

## ----------------------------------------------------------------------------
# some chars

$text =<<'EOF';
"<>&
EOF

$html_exp =<<'EOF';
<p>&quot;&lt;&gt;&amp;</p>
EOF

$html_got = $normal->text2html( $text );
is($html_got, $html_exp, 'normal');

$html_got = $basic->text2html( $text );
is($html_got, $html_exp, 'basic');

## ----------------------------------------------------------------------------
