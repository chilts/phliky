## -------------------------------------------------------------------*-perl-*-
package Text::Phliky;

use strict;
use warnings;
use Carp;
use vars qw($VERSION);

$VERSION = '0.1';

use HTML::Entities;
use URI::Escape;
use Regexp::Common;

## ----------------------------------------------------------------------------
# constants

my $C = 'constant';

## ----------------------------------------------------------------------------
# new

sub new {
    my ($invocant, $args) = @_;
    my $self = bless {}, ref $invocant || $invocant;
    return $self;
}

## ----------------------------------------------------------------------------
# class functions

sub esc {
    my ($class, $text) = @_;
    return encode_entities($text);
}

sub uri {
    my ($class, $text) = @_;
    return uri_escape($text);
}

## ----------------------------------------------------------------------------
# methods

sub text2html {
    my ($self, $text) = @_;
    my $html;

    chomp $text;
    my @paras = split /\n\n+/, $text;
    my @html;
    foreach my $para ( @paras ) {
        push @html, $self->parse_para( $para );
    }

    return join '', @html;
}

sub parse_para {
    my ($self, $para) = @_;
    if ( $para =~ m{ \A \!([123456]) \s (.*) \z }xms ) {
        $para = $2;
        return "<h$1>" . $self->esc($para) . "</h$1>\n";
    }
    elsif ( $para =~ m{ \A \s }xms ) {
        return "<pre>\n" . $self->esc($para) . "\n</pre>\n";
    }
    elsif ( $para =~ m{ \A \^ \s (.*) \z }xms ) {
        $para = $1;
        return "<p style=\"text-align: center;\">" . $self->parse_inline( $self->esc($para) ) . "</p>\n";
    }
    elsif ( $para =~ m{ \A ([\#\*]) \s .* \z }xms ) {
        return $self->list( $1, $para );
    }
    else {
        # unknown paragraph style, output as normal
        return "<p>" . $self->parse_inline( $self->esc($para) ) . "</p>\n";
    }
    return "[program error]";
}

sub list {
    my ($self, $type, $para) = @_;
    my $indent = 0;

    # make the para into lines
    my @lines = split m{\n}xms, $para;

    my $element = $type eq '#' ? 'ol' : 'ul';

    my $html = "<$element>\n";
    foreach my $items ( @lines ) {
        $items =~ s{ \A [\#\*] \s }{}xms;
        $html .= '  <li>' . $self->parse_inline( $self->esc($items) ) . "</li>\n";
    }
    $html .= "</$element>\n";
    return $html;
}

sub parse_inline {
    my ($self, $line) = @_;
    # do stuff
    while ( my ($type, $str) = $line =~ m{ \\([a-z]*)($RE{balanced}{-parens=>'{}'}) }xms ) {
        $str =~ s{ \A \{ }{}gxms;
        $str =~ s{ \} \z }{}gxms;
        if ( $type eq 'b' ) {
            $line =~ s{ \\b ($RE{balanced}{-parens=>'{}'}) }{<b>$str</b>}xms;
        }
        elsif ( $type eq 'i' ) {
            $line =~ s{ \\i ($RE{balanced}{-parens=>'{}'}) }{<em>$str</em>}xms;
        }
        elsif ( $type eq 'c' ) {
            $line =~ s{ \\c ($RE{balanced}{-parens=>'{}'}) }{<code>$str</code>}xms;
        }
        elsif ( $type eq 'l' ) {
            my ($text, $href) = $str =~ m{ \A ([^\|]*) \| (.*) \z }xms;
            $line =~ s{ \\l ($RE{balanced}{-parens=>'{}'}) }{<a href="$href">$text</a>}xms;
        }
        elsif ( $type eq 'p' ) {
            my ($text, $href) = $str =~ m{ \A ([^\|]*) \| (.*) \z }xms;
            $line =~ s{ \\p ($RE{balanced}{-parens=>'{}'}) }{<a target="_new" href="$href">$text</a>}xms;
        }
        elsif ( $type eq 'img' ) {
            my ($title, $src) = $str =~ m{ \A ([^\|]*) \| (.*) \z }xms;
            return '<img src="' . $src . '" title="' . $title . "\" />\n";
        }

        else {
            $line =~ s{ \\([a-z]*) ($RE{balanced}{-parens=>'{}'}) }{\\[$1]{$str}}xms;
        }
    }

    return $line;
}

## ----------------------------------------------------------------------------
1;
## ----------------------------------------------------------------------------

=head1 NAME

B<Text::Phliky> - A Wiki/Blog-Type text to html converter.


=head1 SYNOPSIS

    use Text::Phliky;
    my $phliky = Text::Phliky->new();
    my $html = $phliky->text2html($str);

=head1 DESCRIPTION



=head1 EXAMPLE


=head1 BUGS

text

=head1 AUTHOR

Andrew Chilton B<andy@kapiti.geek.nz>

Copyright (c) 2006 Andrew Chilton.  All rights reserved.  All wrongs reversed.
This program is free software; you can redistribute and/or modify it under the
same terms as Perl itself.

=head1 ACKNOWLEDGMENTS

B<A Name>
found bug where two spaces didn't get converted

=cut
