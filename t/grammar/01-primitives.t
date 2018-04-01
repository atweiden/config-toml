use v6;
use lib 'lib';
use Test;
use Config::TOML::Parser::Grammar;

plan(5);

# comment grammar tests {{{

subtest({
    my Str $comment = '# Yeah, you can do this.';

    my $match-comment = Config::TOML::Parser::Grammar.parse(
        $comment,
        :rule<comment>
    );

    is(
        $match-comment.WHAT,
        Config::TOML::Parser::Grammar,
        q:to/EOF/
        ♪ [Grammar.parse($comment, :rule<comment>)] - 1 of 30
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Parses string literal comment successfully
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
});

# end comment grammar tests }}}
# string grammar tests {{{

subtest({
    my Str $string-basic = Q:to/EOF/.trim;
    "I'm a string with backslashes (\\). \"You can quote me\". Name\tJosh\nLocation\tSF.\\"
    EOF

    my Str $string-basic-backslash = Q:to/EOF/.trim;
    "I'm a string ending with a backslash followed by a whitespace\\ "
    EOF

    my Str $string-basic-empty = Q:to/EOF/.trim;
    ""
    EOF

    my Str $string-basic-multiline = Q:to/EOF/.trim;
    """\
    asdf	<-- tab
    \"\"\"
    \"""
    what
    """
    EOF

    my Str $string-literal = Q:to/EOF/.trim;
    '\\\Server\X\admin$\system32\\\\\\'
    EOF

    my Str $string-literal-empty = Q:to/EOF/.trim;
    ''
    EOF

    my Str $string-literal-multiline = Q:to/EOF/.trim;
    '''\
    asdf		<-- two tabs
    \'\'\'
    what
    '''
    EOF

    my $match-string-basic =
        Config::TOML::Parser::Grammar.parse(
            $string-basic,
            :rule<string-basic>
        );
    my $match-string-basic-backslash =
        Config::TOML::Parser::Grammar.parse(
            $string-basic-backslash,
            :rule<string-basic>
        );
    my $match-string-basic-empty =
        Config::TOML::Parser::Grammar.parse(
            $string-basic-empty,
            :rule<string-basic>
        );
    my $match-string-basic-multiline =
        Config::TOML::Parser::Grammar.parse(
            $string-basic-multiline,
            :rule<string-basic-multiline>
        );
    my $match-string-literal =
        Config::TOML::Parser::Grammar.parse(
            $string-literal,
            :rule<string-literal>
        );
    my $match-string-literal-empty =
        Config::TOML::Parser::Grammar.parse(
            $string-literal-empty,
            :rule<string-literal>
        );
    my $match-string-literal-multiline =
        Config::TOML::Parser::Grammar.parse(
            $string-literal-multiline,
            :rule<string-literal-multiline>
        );

    is(
        $match-string-basic.WHAT,
        Config::TOML::Parser::Grammar,
        q:to/EOF/
        ♪ [Grammar.parse($string-basic, :rule<string-basic>)] - 2 of 30
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Parses double quoted string successfully
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );

    is(
        $match-string-basic-backslash.WHAT,
        Config::TOML::Parser::Grammar,
        q:to/EOF/
        ♪ [Grammar.parse(
              $string-basic-backslash,
              :rule<string-basic>
           )] - 3 of 30
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Parses double quoted string successfully
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );

    is(
        $match-string-basic-empty.WHAT,
        Config::TOML::Parser::Grammar,
        q:to/EOF/
        ♪ [Grammar.parse($string-basic-empty, :rule<string-basic>)] - 4 of 30
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Parses double quoted empty string successfully
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );

    is(
        $match-string-basic-multiline.WHAT,
        Config::TOML::Parser::Grammar,
        q:to/EOF/
        ♪ [Grammar.parse(
            $string-basic-multiline,
            :rule<string-basic-multiline>
           )] - 5 of 30
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Parses double quoted multiline string successfully
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );

    is(
        $match-string-literal.WHAT,
        Config::TOML::Parser::Grammar,
        q:to/EOF/
        ♪ [Grammar.parse($string-literal, :rule<string-literal>)] - 6 of 30
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Parses single quoted string successfully
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );

    is(
        $match-string-literal-empty.WHAT,
        Config::TOML::Parser::Grammar,
        q:to/EOF/
        ♪ [Grammar.parse(
              $string-literal-empty,
              :rule<string-literal>
           )] - 7 of 30
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Parses single quoted empty string successfully
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );

    is(
        $match-string-literal-multiline.WHAT,
        Config::TOML::Parser::Grammar,
        q:to/EOF/
        ♪ [Grammar.parse(
              $string-literal-multiline,
              :rule<string-literal-multiline>
           )] - 8 of 30
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Parses single quoted multiline string
        ┃   Success   ┃    successfully
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
});

# end string grammar tests }}}
# number grammar tests {{{

subtest({
    my Str $integer-basic = '-1';
    my Str $integer-underscore = '1_000_000';
    my Str $float-basic = '-0.1';
    my Str $float-underscore = '+1_000_000_000.111_111_111';
    my Str $float-exponent = '1e1_000';
    my Str $float-exponent-underscore = '987_654.321e1_234_567';

    my $match-integer-basic =
        Config::TOML::Parser::Grammar.parse(
            $integer-basic,
            :rule<integer>
        );
    my $match-integer-underscore =
        Config::TOML::Parser::Grammar.parse(
            $integer-underscore,
            :rule<integer>
        );
    my $match-float-basic =
        Config::TOML::Parser::Grammar.parse(
            $float-basic,
            :rule<float>
        );
    my $match-float-underscore =
        Config::TOML::Parser::Grammar.parse(
            $float-underscore,
            :rule<float>
        );
    my $match-float-exponent =
        Config::TOML::Parser::Grammar.parse(
            $float-exponent,
            :rule<float>
        );
    my $match-float-exponent-underscore =
        Config::TOML::Parser::Grammar.parse(
            $float-exponent-underscore,
            :rule<float>
        );

    is(
        $match-integer-basic.WHAT,
        Config::TOML::Parser::Grammar,
        q:to/EOF/
        ♪ [Grammar.parse($integer-basic, :rule<integer>)] - 9 of 30
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Parses string literal integer successfully
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );

    is(
        $match-integer-underscore.WHAT,
        Config::TOML::Parser::Grammar,
        q:to/EOF/
        ♪ [Grammar.parse($integer-underscore, :rule<integer>)] - 10 of 30
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Parses string literal integer (with
        ┃   Success   ┃    underscores) successfully
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );

    is(
        $match-float-basic.WHAT,
        Config::TOML::Parser::Grammar,
        q:to/EOF/
        ♪ [Grammar.parse($float-basic, :rule<float>)] - 11 of 30
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Parses string literal float successfully
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );

    is(
        $match-float-underscore.WHAT,
        Config::TOML::Parser::Grammar,
        q:to/EOF/
        ♪ [Grammar.parse($float-underscore, :rule<float>)] - 12 of 30
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Parses string literal float (with underscores)
        ┃   Success   ┃    successfully
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );

    is(
        $match-float-exponent.WHAT,
        Config::TOML::Parser::Grammar,
        q:to/EOF/
        ♪ [Grammar.parse($float-exponent, :rule<float>)] - 13 of 30
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Parses string literal float (with exponent)
        ┃   Success   ┃    successfully
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );

    is(
        $match-float-exponent-underscore.WHAT,
        Config::TOML::Parser::Grammar,
        q:to/EOF/
        ♪ [Grammar.parse($float-exponent-underscore, :rule<float>)] - 14 of 30
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Parses string literal float (with exponent
        ┃   Success   ┃    and underscores) successfully
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
});

# end number grammar tests }}}
# boolean grammar tests {{{

subtest({
    my Str $boolean-true = 'true';
    my Str $boolean-false = 'false';

    my $match-boolean-true =
        Config::TOML::Parser::Grammar.parse(
            $boolean-true,
            :rule<boolean>
        );
    my $match-boolean-false =
        Config::TOML::Parser::Grammar.parse(
            $boolean-false,
            :rule<boolean>
        );

    is(
        $match-boolean-true.WHAT,
        Config::TOML::Parser::Grammar,
        q:to/EOF/
        ♪ [Grammar.parse($boolean-true, :rule<boolean>)] - 15 of 30
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Parses string literal true successfully
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );

    is(
        $match-boolean-false.WHAT,
        Config::TOML::Parser::Grammar,
        q:to/EOF/
        ♪ [Grammar.parse($boolean-false, :rule<boolean>)] - 16 of 30
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Parses string literal false successfully
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
});

# end boolean grammar tests }}}
# datetime grammar tests {{{

subtest({
    # Datetimes are RFC 3339 dates.
    my Str $date-time1 = Q{1979-05-27T07:32:00Z};
    my Str $date-time2 = Q{1979-05-27T00:32:00-07:00};
    my Str $date-time3 = Q{1979-05-27T00:32:00.999999-07:00};
    my Str $date-time4 = Q{1979-05-27T07:32:00};
    my Str $date-time5 = Q{1979-05-27T00:32:00.999999};
    my Str $date-time6 = Q{1979-05-27 07:32:00Z};
    my Str $full-date1 = Q{1979-05-27};

    # *-proto vars test for match against proto token date
    my $match-date-time1 =
        Config::TOML::Parser::Grammar.parse(
            $date-time1,
            :rule<date-time>
        );
    my $match-date-time1-proto =
        Config::TOML::Parser::Grammar.parse(
            $date-time1,
            :rule<date>
        );
    my $match-date-time2 =
        Config::TOML::Parser::Grammar.parse(
            $date-time2,
            :rule<date-time>
        );
    my $match-date-time2-proto =
        Config::TOML::Parser::Grammar.parse(
            $date-time2,
            :rule<date>
        );
    my $match-date-time3 =
        Config::TOML::Parser::Grammar.parse(
            $date-time3,
            :rule<date-time>
        );
    my $match-date-time3-proto =
        Config::TOML::Parser::Grammar.parse(
            $date-time3,
            :rule<date>
        );
    my $match-date-time4 =
        Config::TOML::Parser::Grammar.parse(
            $date-time4,
            :rule<date-time-omit-local-offset>
        );
    my $match-date-time4-proto =
        Config::TOML::Parser::Grammar.parse(
            $date-time4,
            :rule<date>
        );
    my $match-date-time5 =
        Config::TOML::Parser::Grammar.parse(
            $date-time5,
            :rule<date-time-omit-local-offset>
        );
    my $match-date-time5-proto =
        Config::TOML::Parser::Grammar.parse(
            $date-time5,
            :rule<date>
        );
    my $match-date-time6 =
        Config::TOML::Parser::Grammar.parse(
            $date-time6,
            :rule<date-time>
        );
    my $match-date-time6-proto =
        Config::TOML::Parser::Grammar.parse(
            $date-time6,
            :rule<date>
        );
    my $match-full-date1 =
        Config::TOML::Parser::Grammar.parse(
            $full-date1,
            :rule<full-date>
        );
    my $match-full-date1-proto =
        Config::TOML::Parser::Grammar.parse(
            $full-date1,
            :rule<date>
        );

    is(
        $match-date-time1.WHAT,
        Config::TOML::Parser::Grammar,
        q:to/EOF/
        ♪ [Grammar.parse($date-time1, :rule<date-time>)] - 17 of 30
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Parses string literal datetime successfully
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match-date-time1-proto.WHAT,
        Config::TOML::Parser::Grammar,
        q:to/EOF/
        ♪ [Grammar.parse($date-time1, :rule<date>)] - 18 of 30
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Parses string literal datetime successfully
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match-date-time2.WHAT,
        Config::TOML::Parser::Grammar,
        q:to/EOF/
        ♪ [Grammar.parse($date-time2, :rule<date-time>)] - 19 of 30
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Parses string literal datetime successfully
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match-date-time2-proto.WHAT,
        Config::TOML::Parser::Grammar,
        q:to/EOF/
        ♪ [Grammar.parse($date-time2, :rule<date>)] - 20 of 30
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Parses string literal datetime successfully
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match-date-time3.WHAT,
        Config::TOML::Parser::Grammar,
        q:to/EOF/
        ♪ [Grammar.parse($date-time3, :rule<date-time>)] - 21 of 30
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Parses string literal datetime successfully
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match-date-time3-proto.WHAT,
        Config::TOML::Parser::Grammar,
        q:to/EOF/
        ♪ [Grammar.parse($date-time3, :rule<date>)] - 22 of 30
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Parses string literal datetime successfully
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match-date-time4.WHAT,
        Config::TOML::Parser::Grammar,
        q:to/EOF/
        ♪ [Grammar.parse(
               $date-time4,
               :rule<date-time-omit-local-offset>
           )] - 23 of 30
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Parses string literal datetime (omit local offset)
        ┃   Success   ┃    successfully
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match-date-time4-proto.WHAT,
        Config::TOML::Parser::Grammar,
        q:to/EOF/
        ♪ [Grammar.parse($date-time4, :rule<date>)] - 24 of 30
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Parses string literal datetime (omit local offset)
        ┃   Success   ┃    successfully
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match-date-time5.WHAT,
        Config::TOML::Parser::Grammar,
        q:to/EOF/
        ♪ [Grammar.parse(
               $date-time5,
               :rule<date-time-omit-local-offset>
           )] - 25 of 30
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Parses string literal datetime (omit local offset)
        ┃   Success   ┃    successfully
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match-date-time5-proto.WHAT,
        Config::TOML::Parser::Grammar,
        q:to/EOF/
        ♪ [Grammar.parse($date-time5, :rule<date>)] - 26 of 30
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Parses string literal datetime (omit local offset)
        ┃   Success   ┃    successfully
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match-date-time6.WHAT,
        Config::TOML::Parser::Grammar,
        q:to/EOF/
        ♪ [Grammar.parse($date-time6, :rule<date-time>)] - 27 of 30
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Parses string literal datetime (omit T delimiter)
        ┃   Success   ┃    successfully
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match-date-time6-proto.WHAT,
        Config::TOML::Parser::Grammar,
        q:to/EOF/
        ♪ [Grammar.parse($date-time6, :rule<date>)] - 28 of 30
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Parses string literal datetime (omit T delimiter)
        ┃   Success   ┃    successfully
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match-full-date1.WHAT,
        Config::TOML::Parser::Grammar,
        q:to/EOF/
        ♪ [Grammar.parse($full-date1, :rule<full-date>)] - 29 of 30
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Parses string literal datetime (omit local offset
        ┃   Success   ┃    and time) successfully
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match-full-date1-proto.WHAT,
        Config::TOML::Parser::Grammar,
        q:to/EOF/
        ♪ [Grammar.parse($full-date1, :rule<date>)] - 30 of 30
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Parses string literal datetime (omit local offset
        ┃   Success   ┃    and time) successfully
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
});

# end datetime grammar tests }}}

# vim: set filetype=perl6 foldmethod=marker foldlevel=0:
