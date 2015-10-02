use v6;
unit grammar Config::TOML::Parser::Grammar;

token ws
{
    # When parsing file formats where some whitespace (for example
    # vertical whitespace) is significant, it is advisable to
    # override ws:
    <!ww>    # only match when not within a word
    \h*      # only match horizontal whitespace
}

# comment grammar {{{

token comment
{
    '#' <comment_text>
}

token comment_text
{
    \N*
}

# end comment grammar }}}
# string grammar {{{

token string
{
    <string_basic_multiline>
    || <string_basic>
    || <string_literal_multiline>
    || <string_literal>
}

token string_basic
{
    '"' <string_basic_text> '"'
}

token string_basic_text
{
    [ <+[\N] -[\" \\]> || \\ \N ]*
}

token string_basic_multiline
{
    <string_basic_multiline_delimiters>
    \n*
    <string_basic_multiline_text>
    <string_basic_multiline_delimiters>
}

token string_basic_multiline_text
{
    <-string_basic_multiline_delimiters>*
}

token string_basic_multiline_delimiters
{
    <!after \\> '"""'
}

token string_literal
{
    \' <string_literal_text> \'
}

token string_literal_text
{
    # Since there is no escaping, there is no way to write a single
    # quote inside a literal string enclosed by single quotes. Luckily,
    # TOML supports a multi-line version of literal strings that solves
    # this problem.
    <+[\N] -[\']>*
}

token string_literal_multiline
{
    <string_literal_multiline_delimiters>
    \n*
    <string_literal_multiline_text>
    <string_literal_multiline_delimiters>
}

token string_literal_multiline_text
{
    <-string_literal_multiline_delimiters>*
}

token string_literal_multiline_delimiters
{
    \'\'\'
}

# end string grammar }}}
# number grammar {{{

token number
{
    <float> || <integer>
}

token plus_or_minus
{
    '+' || '-'
}

token digits
{
    \d+

    |

    # For large numbers, you may use underscores to enhance
    # readability. Each underscore must be surrounded by at least
    # one digit.
    \d+ '_' <.digits>
}

token whole_number
{
    0

    ||

    # Leading zeros are not allowed.
    <[1..9]> [ '_'? <.digits> ]?
}

token integer
{
    <plus_or_minus>? <whole_number>
}

token exponent_part
{
    <[Ee]> <integer_part=.integer>
}

token float
{
    <integer_part=.integer>
    [
        '.' <fractional_part=.digits> <exponent_part>?
        || <exponent_part>
    ]
}

# end number grammar }}}
# boolean grammar {{{

token boolean
{
    # Booleans are just the tokens you're used to. Always lowercase.
    true || false
}

# end boolean grammar }}}
# datetime grammar {{{

# Datetimes are RFC 3339 dates: http://tools.ietf.org/html/rfc3339

token date_fullyear
{
    \d ** 4
}

token date_month
{
    0 <[1..9]> || 1 <[0..2]>
}

token date_mday
{
    0 <[1..9]> || <[1..2]> \d || 3 <[0..1]>
}

token time_hour
{
    <[0..1]> \d || 2 <[0..3]>
}

token time_minute
{
    <[0..5]> \d
}

token time_second
{
    # The grammar element time-second may have the value "60" at the end
    # of months in which a leap second occurs.
    <[0..5]> \d || 60
}

token time_secfrac
{
    '.' \d+
}

token time_numoffset
{
    <plus_or_minus> <time_hour> ':' <time_minute>
}

token time_offset
{
    <[Zz]> || <time_numoffset>
}

token partial_time
{
    <time_hour> ':' <time_minute> ':' <time_second> <time_secfrac>?
}

token full_date
{
    <date_fullyear> '-' <date_month> '-' <date_mday>
}

token full_time
{
    <partial_time> <time_offset>
}

token date_time
{
    <full_date> T <full_time>
}

# end datetime grammar }}}
# array grammar {{{

token array
{
    '['
    \s*
    <array_comment>
    [ <array_elements> [\s* ',']? ]?
    \s*
    <array_comment>
    ']'
}

token array_comment
{
    [ \s* <comment> \n \s* ]*
}

token array_elements
{
    <array_of_strings>
    || <array_of_date_times>
    || <array_of_floats>
    || <array_of_integers>
    || <array_of_booleans>
    || <array_of_arrays>
}

token array_of_strings
{
    <string>
    [
        \s*
        [ ',' \s* <array_comment> || <array_comment> ',' <array_comment> ]
        \s*
        <string>
    ]*
}

token array_of_integers
{
    <integer>
    [
        \s*
        [ ',' \s* <array_comment> || <array_comment> ',' <array_comment> ]
        \s*
        <integer>
    ]*
}

token array_of_floats
{
    <float>
    [
        \s*
        [ ',' \s* <array_comment> || <array_comment> ',' <array_comment> ]
        \s*
        <float>
    ]*
}

token array_of_booleans
{
    <boolean>
    [
        \s*
        [ ',' \s* <array_comment> || <array_comment> ',' <array_comment> ]
        \s*
        <boolean>
    ]*
}

token array_of_date_times
{
    <date_time>
    [
        \s*
        [ ',' \s* <array_comment> || <array_comment> ',' <array_comment> ]
        \s*
        <date_time>
    ]*
}

token array_of_arrays
{
    <array>
    [
        \s*
        [ ',' \s* <array_comment> || <array_comment> ',' <array_comment> ]
        \s*
        <array>
    ]*
}

# end array grammar }}}
# table grammar {{{

token keypair
{
    <keypair_key> \h* '=' \h* <keypair_value>
}

token keypair_key
{
    <keypair_key_quoted=.string_basic> || <keypair_key_bare>
}

token keypair_key_bare
{
    <+alnum +[-]>+
}

token keypair_value
{
    <table_inline>
    || <array>
    || <string>
    || <date_time>
    || <number>
    || <boolean>
}

token table_inline_keypairs
{
    <keypair>
    [
        \s*
        [
            ',' \s* <table_inline_comment=.array_comment>
            || <table_inline_comment=.array_comment> ','
               <table_inline_comment=.array_comment>
        ]
        \s*
        <keypair>
    ]*
}

token table_inline
{
    '{'
    \s*
    <table_inline_comment=.array_comment>
    [ <table_inline_keypairs> [\s* ',']? ]?
    \s*
    <table_inline_comment=.array_comment>
    '}'
}

# end table grammar }}}

# vim: ft=perl6 fdm=marker fdl=0
