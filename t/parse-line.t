#!/usr/bin/perl
## ----------------------------------------------------------------------------

use strict;
use warnings;

use Test::More;
use Data::Dumper;

use Text::Phliky;

## ----------------------------------------------------------------------------

plan tests => 33;

## ----------------------------------------------------------------------------
# create the object and some variables

my $phliky = Text::Phliky->new();
my ($text, $type, $attr, $rest);

## ----------------------------------------------------------------------------
# fail

$text = "something here";
($type, $attr, $rest) = $phliky->parse_generic_line($text);
is($type, undef);
is_deeply($attr, undef);
is($rest, 'something here');

## ----------------------------------------------------------------------------
# a br

$text = "-";
($type, $attr, $rest) = $phliky->parse_generic_line($text);
is($type, '-');
is_deeply($attr, {});
is($rest, undef);

## ----------------------------------------------------------------------------
# a br

$text = "- ";
($type, $attr, $rest) = $phliky->parse_generic_line($text);
is($type, '-');
is_deeply($attr, {});
is($rest, undef);

## ----------------------------------------------------------------------------
# a br

$text = "-{}";
($type, $attr, $rest) = $phliky->parse_generic_line($text);
is($type, '-');
is_deeply($attr, {});
is($rest, undef);

## ----------------------------------------------------------------------------
# a br

$text = "-{} ";
($type, $attr, $rest) = $phliky->parse_generic_line($text);
is($type, '-');
is_deeply($attr, {});
is($rest, undef);

## ----------------------------------------------------------------------------
# centered

$text = "^ the rest";
($type, $attr, $rest) = $phliky->parse_generic_line($text);
is($type, '^');
is_deeply($attr, {});
is($rest, 'the rest');

## ----------------------------------------------------------------------------
# centered

$text = "^{} the rest";
($type, $attr, $rest) = $phliky->parse_generic_line($text);
is($type, '^');
is_deeply($attr, {});
is($rest, 'the rest');

## ----------------------------------------------------------------------------
# some attributes

$text = "%{id=email}";
($type, $attr, $rest) = $phliky->parse_generic_line($text);
is($type, '%');
is_deeply($attr, { id => 'email' });
is($rest, undef);

## ----------------------------------------------------------------------------
# more attributes

$text = "%{id=email|class=this}";
($type, $attr, $rest) = $phliky->parse_generic_line($text);
is($type, '%');
is_deeply($attr, { id => 'email', class => 'this' });
is($rest, undef);

## ----------------------------------------------------------------------------
# almost everything

$text = "%{id=email} something here";
($type, $attr, $rest) = $phliky->parse_generic_line($text);
is($type, '%');
is_deeply($attr, { id => 'email' });
is($rest, 'something here');

## ----------------------------------------------------------------------------
# everything

$text = "%{id=email|class=this} something here";
($type, $attr, $rest) = $phliky->parse_generic_line($text);
is($type, '%');
is_deeply($attr, { id => 'email', class => 'this' });
is($rest, 'something here');

## ----------------------------------------------------------------------------
