#!/usr/bin/perl
## -------------------------------------------------------------------*-perl-*-

use strict;
use warnings;

use Test::More;
use HTML::Entities;

use Text::Phliky;

## ----------------------------------------------------------------------------

plan tests => 1;

## ----------------------------------------------------------------------------
# create the object and some variables

my $phliky = Text::Phliky->new();
my ($text, $html_exp, $html_got);

## ----------------------------------------------------------------------------
# check the HTML::Entities version

$text = "An ' apostrophe";

if ( $HTML::Entities::VERSION eq '1.29' ) {
    $html_exp = "<p>An ' apostrophe</p>\n";
}
elsif ( $HTML::Entities::VERSION eq '1.32' ) {
    $html_exp = "<p>An &#39; apostrophe</p>\n";
}
elsif ( $HTML::Entities::VERSION eq '1.35' ) {
    $html_exp = "<p>An &#39; apostrophe</p>\n";
}
else {
    $html_exp = "<p>An ' apostrophe</p>\n";
}

$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, 'complex paragraph');

## ----------------------------------------------------------------------------
