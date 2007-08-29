## -------------------------------------------------------------------*-perl-*-
package Text::Phliky;

use strict;
use warnings;
use Carp;
use base qw(Class::Accessor);
use vars qw($VERSION);
use HTML::Entities;
use URI::Escape;
use Regexp::Common;
$VERSION = '0.2';

my $entity = {
    copy => '&copy;',
};

my $lut = {
    table => {
        '[' => 'thead',
        ']' => 'tfoot',
        '-' => 'tbody',
    },
    mode => {
        basic => 1,
        normal => 1,
    },
};

Text::Phliky->mk_accessors(qw(text mode));

## ----------------------------------------------------------------------------
# class functions

sub new {
    my ($class, $args) = @_;

    my $self = {};
    bless $self, ref $class || $class;

    $self->{mode} = $args->{mode} || 'normal';

    return $self;
}

sub uri {
    my ($class, $text) = @_;
    return uri_escape($text);
}

## ----------------------------------------------------------------------------
# instance methods

sub html {
    my ($self) = @_;
    return $self->text2html( $self->{text} );
}

sub mode {
    my ($self, $mode) = @_;
    if ( exists $lut->{mode}{$mode} ) {
        $self->mode();
    }
}

sub esc {
    my ($self, $text) = @_;

    if ( $self->{mode} eq 'basic' ) {
        return encode_entities($text, '&<>"');
    }
    elsif ( $self->{mode} eq 'normal' ) {
        return encode_entities($text);
    }
    return '';
}

## ----------------------------------------------------------------------------
# class methods

sub text2html {
    my ($self, $text) = @_;
    return unless defined $text;

    chomp $text;

    # join lines up which should be together
    $text =~ s{ \\\n\s+ }{ }gxms;

    my @html;
    my @chunks = split /\n\n+/, $text;
    foreach my $chunk ( @chunks ) {
        push @html, $self->parse_chunk( $chunk );
    }

    return join '', @html;
}

sub parse_chunk {
    my ($self, $chunk) = @_;
    if ( $chunk =~ m{ \A \!([123456])(?:{([\w-]+)})? \s (.*) \z }xms ) {
        # headings
        my $level = $1;
        my $name = $2;
        $chunk = $3;

        my $html = '';
        if ( defined $name ) {
            $html .= '<a name="' . $self->esc($name) . "\"> </a>\n";
        }
        $html .= "<h$1>" . $self->esc($chunk) . "</h$1>\n";
        return $html;
    }
    elsif ( $chunk =~ m{ \A \s }xms ) {
        # pre-formatted text
        return "<pre>\n" . $self->esc($chunk) . "\n</pre>\n";
    }
    elsif ( $chunk =~ m{ \A \^ \s (.*) \z }xms ) {
        # a centered paragraph
        $chunk = $1;
        return "<p style=\"text-align: center;\">" . $self->parse_inline( $self->esc($chunk) ) . "</p>\n";
    }
    elsif ( $chunk =~ m{ \A ~{(\w+)} \s (.*) \z }xms ) {
        # a paragraph with a class
        my $class = $1;
        $chunk = $2;
        return "<p class=\"$class\">" . $self->parse_inline( $self->esc($chunk) ) . "</p>\n";
    }
    elsif ( $chunk =~ m{ \A < \s (.*) \z }xms ) {
        # just a HTML paragraph
        $chunk = $1;
        return "$chunk\n";
    }
    elsif ( $chunk =~ m{ \A ([\#\*]) \s .* \z }xms ) {
        # a list of some sort
        return $self->list( $chunk );
    }
    elsif ( $chunk =~ m{ \A : \s (.*) \z }xms ) {
        # a definition list
        return $self->definition( $1 );
    }
    elsif ( $chunk =~ m{ \A (\[) \s .* \z }xms ) {
        # a table
        return $self->table( $chunk );
    }
    elsif ( $chunk =~ m{ \A (\-) \s .* \z }xms ) {
        # a horizontal rule
        return "<hr />";
    }
    elsif ( $chunk =~ m{ \A \" \s (.*) \z }xms ) {
        # a quote
        $chunk = $1;
        return "<quote>" . $self->parse_inline( $self->esc($chunk) ) . "</quote>\n";
    }
    else {
        # unknown chunk style, output as normal
        return "<p>" . $self->parse_inline( $self->esc($chunk) ) . "</p>\n";
    }
    return "[program error]";
}

sub list {
    my ($self, $chunk) = @_;

    # make the para into lines
    my @lines = split m{\n}xms, $chunk;

    return '' unless @lines;

    my $html = '';
    my $indent = [];

    foreach my $line (@lines) {
        my ($type, $length, $content) = $self->list_line_info( $line );

        if ( $length == @$indent ) {
            $html .= "</li><li>" . $self->parse_inline( $self->esc($content) );
        }
        elsif ( $length == scalar @$indent+1 ) {
            # $html .= "</li>" unless @$indent == 0;
            push @$indent, $type;
            $html .= "<$type><li>" . $self->parse_inline( $self->esc($content) );
        }
        elsif ( $length < @$indent ) {
            until ( $length == @$indent ) {
                my $t = pop @$indent;
                $html .= "</li></$t>";
            }
            $html .= "</li><li>" . $self->parse_inline( $self->esc($content) );
        }
        else {
            # croak "You can't indent lists by more than one at a time";
            until ( @$indent == $length) {
                push @$indent, $type;
                $html .= "<$type><li>";
            }
            $html .= $self->parse_inline( $self->esc($content) );
        }
    }
    while ( my $t = pop @$indent ) {
        $html .= "</li></$t>";
    }
    return $html;
}

sub list_line_info {
    my ($self, $line) = @_;

    return unless defined $line;

    my ($type, $content) = $line =~ m{ \A ([\#\*]*) \s (.*) \z }xms;
    my $length = length $type;
    $type = substr($type, 0, 1) eq '#' ? 'ol' : 'ul';

    return ($type, $length, $content);
}

sub definition {
    my ($self, $chunk) = @_;

    # make the para into lines
    my @lines = split m{\n}xms, $chunk;

    return '' unless @lines;

    my $html = "<dl>\n";
    foreach my $line (@lines) {
        my ($dt, $dd) = $line =~ m{ \A ([^:]+): \s (.*) \z }xms;
        next unless defined $dt and defined $dd;
        $html .= "  <dt>" . $self->esc($dt) . "</dt>\n";
        $html .= "  <dd>" . $self->esc($dd) . "</dd>\n";
    }
    $html .= "</dl>\n";
    return $html;
}

sub table {
    my ($self, $chunk) = @_;

    # make the para into lines
    my @lines = split m{\n}xms, $chunk;

    return '' unless @lines;

    my $html = '';
    my $indent = [];

    $html .= "<table>\n";

    my $cur_type = '';
    while ( my $line = shift @lines ) {
        my ($type, $rest) = $line =~ m{ \A ([\[\]\-]) \s (.*) \z }xms;

        return '' unless defined $type;

        if ( $cur_type ne $type ) {
            $html .= "  </$lut->{table}{$cur_type}>\n" if $cur_type ne '';
            $cur_type = $type;
            $html .= "  <$lut->{table}{$type}>\n";
        }

        $html .= $self->table_cells( $rest, $cur_type eq '[' ? 'th' : 'td' );
    }
    $html .= "  </$lut->{table}{$cur_type}>\n";
    $html .= "</table>\n";
    return $html;
}

sub table_cells {
    my ($self, $line, $tag) = @_;

    my $html = "    <tr>\n";
    my @cells = split m{ \s+ \| \s+ }xms, $line;
    for my $cell ( @cells ) {
        $html .= "      <$tag>" . $self->parse_inline($cell) . "</$tag>\n";
    }
    $html .= "    </tr>\n";
    return $html;
}

sub parse_inline {
    my ($self, $line) = @_;
    # do stuff
    while ( my ($type, $str) = $line =~ m{ \\([a-z]*)($RE{balanced}{-parens=>'{}'}) }xms ) {
        # remove leading/trailing whitespace
        $str =~ s{ \A \{ }{}gxms;
        $str =~ s{ \} \z }{}gxms;

        if ( $type eq 'b' ) {
            $line =~ s{ \\b ($RE{balanced}{-parens=>'{}'}) }{<strong>$str</strong>}xms;
        }
        elsif ( $type eq 'i' ) {
            $line =~ s{ \\i ($RE{balanced}{-parens=>'{}'}) }{<em>$str</em>}xms;
        }
        elsif ( $type eq 'u' ) {
            $line =~ s{ \\u ($RE{balanced}{-parens=>'{}'}) }{<span style="text-decoration: underline;">$str</span>}xms;
        }
        elsif ( $type eq 'c' ) {
            $line =~ s{ \\c ($RE{balanced}{-parens=>'{}'}) }{<code>$str</code>}xms;
        }
        elsif ( $type eq 'l' ) {
            my ($text, $href) = $str =~ m{ \A ([^\|]*) \| (.*) \z }xms;
            $line =~ s{ \\l ($RE{balanced}{-parens=>'{}'}) }{<a href="$href">$text</a>}xms;
        }
        elsif ( $type eq 'w' ) {
            $line =~ s{ \\w ($RE{balanced}{-parens=>'{}'}) }{<a href="$str.html">$str</a>}xms;
        }
        elsif ( $type eq 'h' ) {
            $line =~ s{ \\h ($RE{balanced}{-parens=>'{}'}) }{<a href="$str">$str</a>}xms;
        }
        elsif ( $type eq 'p' ) {
            my ($text, $href) = $str =~ m{ \A ([^\|]*) \| (.*) \z }xms;
            $line =~ s{ \\p ($RE{balanced}{-parens=>'{}'}) }{<a target="_new" href="$href">$text</a>}xms;
        }
        elsif ( $type eq 'img' ) {
            my ($title, $src) = $str =~ m{ \A ([^\|]*) \| (.*) \z }xms;
            $line =~ s{ \\img ($RE{balanced}{-parens=>'{}'}) }{<img src="$src" title="$title" />}xms;
        }
        elsif ( $type eq 'a' ) {
            my ($abbr, $abbreviation) = $str =~ m{ \A ([^\|]*) \| (.*) \z }xms;
            $line =~ s{ \\a ($RE{balanced}{-parens=>'{}'}) }{<acronym title="$abbreviation">$abbr</acronym>}xms;
        }
        elsif ( $type eq 'br' ) {
            $line =~ s{ \\br ($RE{balanced}{-parens=>'{}'}) }{<br />}xms;
        }
        elsif ( exists $entity->{$type} ) {
            $line =~ s{ \\$type ($RE{balanced}{-parens=>'{}'}) }{$entity->{$type}}xms;
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

B<Text::Phliky> - A Wiki/Blog/News/Content/Article text to html converter.


=head1 SYNOPSIS

    use Text::Phliky;
    my $phliky = Text::Phliky->new();
    my $html = $phliky->text2html($text);

=head1 DESCRIPTION

Given a Phliky text document, this module writes out the text formatted as
HTML. It is very simple, straightforward and independent of an actual wiki. It
was designed this way so that it can be called by a wiki, a content management
system, a news publisher or any number of different applications.

=head2 Methods

=over 4

=item I<PACKAGE>->new()

Returns a new C<Text::Phliky> object. This can be used to convert some text to
HTML.

=item I<$OBJ>->I<text2html>($text)  or  I<PACKAGE>->I<text2html>($text)

Returns the HTML version of the text passed in.

=back

=head1 Parsing

The module is simple in it's process of conversion. Firstly, the text is split
into chunks (anything which has 2 returns between them). Each chunk is then
analysed to determine it's type, be it a heading, preformatted text or a
paragraph.

In some cases, once the chunk type has been decided, it will also be parsed for
inline elements. For example, a normal paragraph or each list item will be
parsed for styles whereas a header or a preformatted text chunk will not. See
below for more details.

=head1 EXAMPLE

    use Text::Phliky;

    my $text <<'PHLIKIDOC';

    !1 A Heading

    This is an introductory paragraph with some styles such as \i{italic},
    \b{bold} and \c{code}. Since it is a normal paragraph, it will be parsed
    for the inline styles.

    * a simple list
    * This \c{too} can contain \b{inline} \i{styles}
    * an \l{external link|http://kapiti.geek.nz/}
    * a \l{popup link|http://kapiti.geek.nz/}

    !2 Headings are not parsed for styles

      /* preformatted text - this chunk starts with 1 or more spaces */
      #include <stdio.h>
      void main() {
          printf("Hello world!\n");
      }

    !2 Definition List

    : Coffee: Black hot drink
    Milk: White cold drink

    PHLIKIDOC

    my $phliky = Text::Phliky->new();
    my $html = $phliky->text2html( $text );

=head1 FUTURE ADDITIONS

At some stage, I will certainly add tables. The fact that multi-level lists are
missing can be considered a bug and needs to be fixed. Other inline styles
which make sense may be added if requested. Up to now, I have added what I need
and haven't needed very much - for it makes nice and uncomplicated pages.

=head1 BUGS

There might be. Please let me know and if possible, please provide an example
of the input text and the HTML you expected to see.

=head1 AUTHOR

Andrew Chilton - andy@kapiti.geek.nz

Copyright (c) 2006 Andrew Chilton.  All rights reserved.  All wrongs reversed.
This program is free software; you can redistribute and/or modify it under the
same terms as Perl itself.

=head1 VERSION

Version 0.2

=head1 SEE ALSO

perl(1)

=cut
