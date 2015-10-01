use v6;
use lib 'lib';
use Test;
use Config::TOML::Parser::Grammar;

plan 5;

# comment grammar tests {{{

subtest
{
    my Str $comment = '# Yeah, you can do this.';

    my $match_comment = Config::TOML::Parser::Grammar.parse(
        $comment,
        :rule<comment>
    );

    is(
        $match_comment.WHAT.perl,
        'Match',
        q:to/EOF/
        ♪ [Config::TOML::Parser::Grammar.parse($comment, :rule<comment>)] - 1 of 18
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Parses string literal comment successfully
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
}

# end comment grammar tests }}}
# string grammar tests {{{

subtest
{
    my Str $string_basic = Q:to/EOF/;
    "I'm a string with backslashes (\\). \"You can quote me\". Name\tJosh\nLocation\tSF.\\"
    EOF
    $string_basic .= trim;

    my Str $string_basic_empty = Q:to/EOF/;
    ""
    EOF
    $string_basic_empty .= trim;

    my Str $string_basic_multiline = Q:to/EOF/;
    """\
    asdf
    what
    """
    EOF
    $string_basic_multiline .= trim;

    my Str $string_literal = Q:to/EOF/;
    '\\\Server\X\admin$\system32\\\\\\'
    EOF
    $string_literal .= trim;

    my Str $string_literal_empty = Q:to/EOF/;
    ''
    EOF
    $string_literal_empty .= trim;

    my Str $string_literal_multiline = Q:to/EOF/;
    '''\
    asdf
    what
    '''
    EOF
    $string_literal_multiline .= trim;

    my $match_string_basic = Config::TOML::Parser::Grammar.parse(
        $string_basic,
        :rule<string_basic>
    );
    my $match_string_basic_empty = Config::TOML::Parser::Grammar.parse(
        $string_basic_empty,
        :rule<string_basic>
    );
    my $match_string_basic_multiline = Config::TOML::Parser::Grammar.parse(
        $string_basic_multiline,
        :rule<string_basic_multiline>
    );
    my $match_string_literal = Config::TOML::Parser::Grammar.parse(
        $string_literal,
        :rule<string_literal>
    );
    my $match_string_literal_empty = Config::TOML::Parser::Grammar.parse(
        $string_literal_empty,
        :rule<string_literal>
    );
    my $match_string_literal_multiline = Config::TOML::Parser::Grammar.parse(
        $string_literal_multiline,
        :rule<string_literal_multiline>
    );

    is(
        $match_string_basic.WHAT.perl,
        'Match',
        q:to/EOF/
        ♪ [Config::TOML::Parser::Grammar.parse($string_basic, :rule<string_basic>)] - 2 of 18
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Parses double quoted string successfully
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );

    is(
        $match_string_basic_empty.WHAT.perl,
        'Match',
        q:to/EOF/
        ♪ [Config::TOML::Parser::Grammar.parse($string_basic_empty, :rule<string_basic>)] - 3 of 18
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Parses double quoted empty string successfully
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );

    is(
        $match_string_basic_multiline.WHAT.perl,
        'Match',
        q:to/EOF/
        ♪ [Config::TOML::Parser::Grammar.parse($string_basic_multiline, :rule<string_basic_multiline>)] - 4 of 18
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Parses double quoted multiline string successfully
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );

    is(
        $match_string_literal.WHAT.perl,
        'Match',
        q:to/EOF/
        ♪ [Config::TOML::Parser::Grammar.parse($string_literal, :rule<string_literal>)] - 5 of 18
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Parses single quoted string successfully
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );

    is(
        $match_string_literal_empty.WHAT.perl,
        'Match',
        q:to/EOF/
        ♪ [Config::TOML::Parser::Grammar.parse($string_literal_empty, :rule<string_literal>)] - 6 of 18
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Parses single quoted empty string successfully
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );

    is(
        $match_string_literal_multiline.WHAT.perl,
        'Match',
        q:to/EOF/
        ♪ [Config::TOML::Parser::Grammar.parse($string_literal_multiline, :rule<string_literal_multiline>)] - 7 of 18
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Parses single quoted multiline string successfully
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
}

# end string grammar tests }}}
# number grammar tests {{{

subtest
{
    my Str $integer_basic = '-1';
    my Str $integer_underscore = '1_000_000';
    my Str $float_basic = '-0.1';
    my Str $float_underscore = '+1_000_000_000.111_111_111';
    my Str $float_exponent = '1e1_000';
    my Str $float_exponent_underscore = '987_654.321e1_234_567';

    my $match_integer_basic = Config::TOML::Parser::Grammar.parse(
        $integer_basic,
        :rule<integer>
    );
    my $match_integer_underscore = Config::TOML::Parser::Grammar.parse(
        $integer_underscore,
        :rule<integer>
    );
    my $match_float_basic = Config::TOML::Parser::Grammar.parse(
        $float_basic,
        :rule<float>
    );
    my $match_float_underscore = Config::TOML::Parser::Grammar.parse(
        $float_underscore,
        :rule<float>
    );
    my $match_float_exponent = Config::TOML::Parser::Grammar.parse(
        $float_exponent,
        :rule<float>
    );
    my $match_float_exponent_underscore = Config::TOML::Parser::Grammar.parse(
        $float_exponent_underscore,
        :rule<float>
    );

    is(
        $match_integer_basic.WHAT.perl,
        'Match',
        q:to/EOF/
        ♪ [Config::TOML::Parser::Grammar.parse($integer_basic, :rule<integer>)] - 8 of 18
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Parses string literal integer successfully
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );

    is(
        $match_integer_underscore.WHAT.perl,
        'Match',
        q:to/EOF/
        ♪ [Config::TOML::Parser::Grammar.parse($integer_underscore, :rule<integer>)] - 9 of 18
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Parses string literal integer (with underscores) successfully
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );

    is(
        $match_float_basic.WHAT.perl,
        'Match',
        q:to/EOF/
        ♪ [Config::TOML::Parser::Grammar.parse($float_basic, :rule<float>)] - 10 of 18
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Parses string literal float successfully
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );

    is(
        $match_float_underscore.WHAT.perl,
        'Match',
        q:to/EOF/
        ♪ [Config::TOML::Parser::Grammar.parse($float_underscore, :rule<float>)] - 11 of 18
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Parses string literal float (with underscores) successfully
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );

    is(
        $match_float_exponent.WHAT.perl,
        'Match',
        q:to/EOF/
        ♪ [Config::TOML::Parser::Grammar.parse($float_exponent, :rule<float>)] - 12 of 18
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Parses string literal float (with exponent) successfully
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );

    is(
        $match_float_exponent_underscore.WHAT.perl,
        'Match',
        q:to/EOF/
        ♪ [Config::TOML::Parser::Grammar.parse($float_exponent_underscore, :rule<float>)] - 13 of 18
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Parses string literal float (with exponent and underscores) successfully
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
}

# end number grammar tests }}}
# boolean grammar tests {{{

subtest
{
    my Str $boolean_true = 'true';
    my Str $boolean_false = 'false';

    my $match_boolean_true = Config::TOML::Parser::Grammar.parse(
        $boolean_true,
        :rule<boolean>
    );
    my $match_boolean_false = Config::TOML::Parser::Grammar.parse(
        $boolean_false,
        :rule<boolean>
    );

    is(
        $match_boolean_true.WHAT.perl,
        'Match',
        q:to/EOF/
        ♪ [Config::TOML::Parser::Grammar.parse($boolean_true, :rule<boolean>)] - 14 of 18
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Parses string literal true successfully
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );

    is(
        $match_boolean_false.WHAT.perl,
        'Match',
        q:to/EOF/
        ♪ [Config::TOML::Parser::Grammar.parse($boolean_false, :rule<boolean>)] - 15 of 18
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Parses string literal false successfully
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
}

# end boolean grammar tests }}}
# datetime grammar tests {{{

subtest
{
    my Str $date1 = '1979-05-27T07:32:00Z';
    my Str $date2 = '1979-05-27T00:32:00-07:00';
    my Str $date3 = '1979-05-27T00:32:00.999999-07:00';

    my $match_date1 = Config::TOML::Parser::Grammar.parse(
        $date1,
        :rule<date_time>
    );
    my $match_date2 = Config::TOML::Parser::Grammar.parse(
        $date2,
        :rule<date_time>
    );
    my $match_date3 = Config::TOML::Parser::Grammar.parse(
        $date3,
        :rule<date_time>
    );

    is(
        $match_date1.WHAT.perl,
        'Match',
        q:to/EOF/
        ♪ [Config::TOML::Parser::Grammar.parse($date1, :rule<date_time>)] - 16 of 18
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Parses string literal datetime successfully
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );

    is(
        $match_date2.WHAT.perl,
        'Match',
        q:to/EOF/
        ♪ [Config::TOML::Parser::Grammar.parse($date2, :rule<date_time>)] - 17 of 18
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Parses string literal datetime successfully
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );

    is(
        $match_date3.WHAT.perl,
        'Match',
        q:to/EOF/
        ♪ [Config::TOML::Parser::Grammar.parse($date3, :rule<date_time>)] - 18 of 18
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Parses string literal datetime successfully
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
}

# end datetime gramar tests }}}

# vim: ft=perl6 fdm=marker fdl=0
