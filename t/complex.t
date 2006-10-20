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
!1 A Heading

This is a paragraph which has \b{bold} and \i{italic}. Also, we have a pre paragraph:

 Like this one
 which outputs the same.

!2 The End

And we're done.

(Ends)
EOF

$html_exp =<<'EOF';
<h1>A Heading</h1>
<p>This is a paragraph which has <strong>bold</strong> and <em>italic</em>. Also, we have a pre paragraph:</p>
<pre>
 Like this one
 which outputs the same.
</pre>
<h2>The End</h2>
<p>And we're done.</p>
<p>(Ends)</p>
EOF

$html_got = $phliky->text2html( $text );

is($html_got, $html_exp, 'complex paragraph');

## ----------------------------------------------------------------------------

$text = "^ \\b{a quote}";
$html_exp = "<p style=\"text-align: center;\"><strong>a quote</strong></p>\n";
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, 'centered');

## ----------------------------------------------------------------------------
