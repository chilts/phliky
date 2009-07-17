#!/usr/bin/perl
## ----------------------------------------------------------------------------

use strict;
use warnings;

use Test::More;
use Data::Dumper;

use Text::Phliky;

## ----------------------------------------------------------------------------

plan tests => 15;

## ----------------------------------------------------------------------------
# create the object and some variables

my $phliky = Text::Phliky->new();
my ($text, $html_exp, $html_got, $name);

## ----------------------------------------------------------------------------
# empty form

$text = q{% action.html};
$html_exp = qq{<form action="action.html">\n</form>\n};
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, 'empty form');

## ----------------------------------------------------------------------------
# empty form (take two)

$text = q{%{} action.html};
$html_exp = qq{<form action="action.html">\n</form>\n};
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, 'empty form (take two)');

## ----------------------------------------------------------------------------
# empty form with id

$text = qq{%{id=myform} action.html};
$html_exp = qq{<form action="action.html" id="myform">\n</form>\n};
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, 'empty form with id');

## ----------------------------------------------------------------------------
# empty form with lots of stuff

$text = qq{%{id=myform|name=a-name|method=POST} action.html\n};
$html_exp = qq{<form action="action.html" id="myform" name="a-name" method="POST">\n</form>\n};
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, 'empty form with lots of stuff');

## ----------------------------------------------------------------------------
# simple form with just text

$text = qq{% action.html\nSome Text Here};
$html_exp = qq{<form action="action.html">
Some Text Here
</form>
};
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, 'empty form with just text');

## ----------------------------------------------------------------------------
# simple form with some Phliky text

$text = qq{% action.html\nSome \\b{Text} Here};
$html_exp = qq{<form action="action.html">
Some <strong>Text</strong> Here
</form>
};
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, 'empty form with some Phliky text');

## ----------------------------------------------------------------------------
# simple form with a <br />

$text = qq{% action.html\n-};
$html_exp = qq{<form action="action.html">
<br />
</form>
};
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, 'empty form with a <br />');

## ----------------------------------------------------------------------------
# form with text input

$text = qq{% action.html
Firstname:
^{name=firstname} Default Value
-
Surname:
^{name=surname}
-
Email:
^{name=email|class=highlight}
};
$html_exp = qq{<form action="action.html">
Firstname:
<input type="text" name="firstname" value="Default Value" />
<br />
Surname:
<input type="text" name="surname" />
<br />
Email:
<input type="text" name="email" class="highlight" />
</form>
};
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, 'form with text input');

## ----------------------------------------------------------------------------
# form with hidden input

$text = qq{% action.html
&{name=something}
&{name=else} hidden
};
$html_exp = qq{<form action="action.html">
<input type="hidden" name="something" />
<input type="hidden" name="else" value="hidden" />
</form>
};
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, 'form with hidden input');

## ----------------------------------------------------------------------------
# form with a label

$text = qq{% action.html
#{for=email} Email
^{id=email|name=email} me\@example.com
};
$html_exp = qq{<form action="action.html">
<label for="email">Email</label>
<input type="text" id="email" name="email" value="me\@example.com" />
</form>
};
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, 'form with a submit button');

## ----------------------------------------------------------------------------
# form with textarea

$text = qq{% action.html
={name=feedback} Something here
};
$html_exp = qq{<form action="action.html">
<textarea name="feedback">
Something here
</textarea>
</form>
};
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, 'form with textarea input');

## ----------------------------------------------------------------------------
# form with a checkbox

$text = qq{% action.html
[{name=vehicle} Bike
[{id=vehicle-car|name=vehicle} Car
};
$html_exp = qq{<form action="action.html">
<input type="checkbox" name="vehicle" value="Bike" />
<input type="checkbox" id="vehicle-car" name="vehicle" value="Car" />
</form>
};
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, 'form with checkbox');

## ----------------------------------------------------------------------------
# form with radio buttons

$text = qq{% action.html
\@{name=sex} Male
\@{id=sex-female|name=sex} Female
};
$html_exp = qq{<form action="action.html">
<input type="radio" name="sex" value="Male" />
<input type="radio" id="sex-female" name="sex" value="Female" />
</form>
};
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, 'form with radio buttons');

## ----------------------------------------------------------------------------
# form with a button

$text = qq{% action.html
! A Button
!{id=button-two} 2nd Button
};
$html_exp = qq{<form action="action.html">
<input type="button" value="A Button" />
<input type="button" id="button-two" value="2nd Button" />
</form>
};
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, 'form with a button');

## ----------------------------------------------------------------------------
# form with a submit button

$text = qq{% action.html
> Submit
};
$html_exp = qq{<form action="action.html">
<input type="submit" value="Submit" />
</form>
};
$html_got = $phliky->text2html( $text );
is($html_got, $html_exp, 'form with a submit button');

## ----------------------------------------------------------------------------
