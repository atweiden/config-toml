use v6;
use lib 'lib';
use Test;
use Config::TOML::Parser::Actions;
use Config::TOML::Parser::Grammar;

plan(2);

subtest({
    my Str $toml-a = Q:to/EOF/;
    a.b.c.d = 123
    EOF

    my Str $toml-b = Q:to/EOF/;
    [a.b.c]
    d = 123
    EOF

    my Str $toml-c = Q:to/EOF/;
    [a.b]
    c.d = 123
    EOF

    my Str $toml-d = Q:to/EOF/;
    [a]
    b.c.d = 123
    EOF

    my Str $toml-e = Q:to/EOF/;
    a = { b = { c = { d = 123 } } }
    EOF

    my Config::TOML::Parser::Actions $actions .= new;
    my $match-toml-a = Config::TOML::Parser::Grammar.parse($toml-a, :$actions);
    my $match-toml-b = Config::TOML::Parser::Grammar.parse($toml-b, :$actions);
    my $match-toml-c = Config::TOML::Parser::Grammar.parse($toml-c, :$actions);
    my $match-toml-d = Config::TOML::Parser::Grammar.parse($toml-d, :$actions);
    my $match-toml-e = Config::TOML::Parser::Grammar.parse($toml-e, :$actions);

    is(
        $match-toml-a.WHAT,
        Config::TOML::Parser::Grammar,
        q:to/EOF/
        ♪ [Grammar.parse($toml-a, :$actions)] - 1 of 14
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Parses TOML with dotted keys successfully
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match-toml-b.WHAT,
        Config::TOML::Parser::Grammar,
        q:to/EOF/
        ♪ [Grammar.parse($toml-b, :$actions)] - 2 of 14
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Parses TOML with dotted keys successfully
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match-toml-c.WHAT,
        Config::TOML::Parser::Grammar,
        q:to/EOF/
        ♪ [Grammar.parse($toml-c, :$actions)] - 3 of 14
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Parses TOML with dotted keys successfully
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match-toml-d.WHAT,
        Config::TOML::Parser::Grammar,
        q:to/EOF/
        ♪ [Grammar.parse($toml-d, :$actions)] - 4 of 14
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Parses TOML with dotted keys successfully
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match-toml-e.WHAT,
        Config::TOML::Parser::Grammar,
        q:to/EOF/
        ♪ [Grammar.parse($toml-e, :$actions)] - 5 of 14
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Parses TOML with dotted keys successfully
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match-toml-a.made<a><b><c><d>,
        123,
        q:to/EOF/
        ♪ [Is expected value?] - 6 of 14
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ $match-toml-a.made<a><b><c><d> == 123
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match-toml-b.made<a><b><c><d>,
        123,
        q:to/EOF/
        ♪ [Is expected value?] - 7 of 14
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ $match-toml-b.made<a><b><c><d> == 123
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match-toml-c.made<a><b><c><d>,
        123,
        q:to/EOF/
        ♪ [Is expected value?] - 8 of 14
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ $match-toml-c.made<a><b><c><d> == 123
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match-toml-d.made<a><b><c><d>,
        123,
        q:to/EOF/
        ♪ [Is expected value?] - 9 of 14
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ $match-toml-d.made<a><b><c><d> == 123
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match-toml-e.made<a><b><c><d>,
        123,
        q:to/EOF/
        ♪ [Is expected value?] - 10 of 14
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ $match-toml-e.made<a><b><c><d> == 123
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
});

subtest({
    my Str $toml-a = Q:to/EOF/;
    [[a]]
    b.c.d = 123
    EOF

    my Str $toml-b = Q:to/EOF/;
    [[a]]
      [a.b.c]
      d = 123
    EOF

    my Str $toml-c = Q:to/EOF/;
    [[a]]
      [a.b]
      c.d = 123
    EOF

    my Str $toml-d = Q:to/EOF/;
    a = [
      { b = { c = { d = 123 } } }
    ]
    EOF

    my Str $toml-e = Q:to/EOF/;
    a = [
      b.c.d = 123
    ]
    EOF

    my Str $toml-f = Q:to/EOF/;
    a = [
      b.c = { d = 123 }
    ]
    EOF

    my Str $toml-g = Q:to/EOF/;
    a = [
      b = { c.d = 123 }
    ]
    EOF

    my Config::TOML::Parser::Actions $actions .= new;
    my $match-toml-a = Config::TOML::Parser::Grammar.parse($toml-a, :$actions);
    my $match-toml-b = Config::TOML::Parser::Grammar.parse($toml-b, :$actions);
    my $match-toml-c = Config::TOML::Parser::Grammar.parse($toml-c, :$actions);
    my $match-toml-d = Config::TOML::Parser::Grammar.parse($toml-d, :$actions);
    my $match-toml-e = Config::TOML::Parser::Grammar.parse($toml-e, :$actions);
    my $match-toml-f = Config::TOML::Parser::Grammar.parse($toml-f, :$actions);
    my $match-toml-g = Config::TOML::Parser::Grammar.parse($toml-g, :$actions);

    is(
        $match-toml-a.WHAT,
        Config::TOML::Parser::Grammar,
        q:to/EOF/
        ♪ [Grammar.parse($toml-a, :$actions)] - 1 of 14
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Parses TOML with dotted keys successfully
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match-toml-b.WHAT,
        Config::TOML::Parser::Grammar,
        q:to/EOF/
        ♪ [Grammar.parse($toml-b, :$actions)] - 2 of 14
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Parses TOML with dotted keys successfully
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match-toml-c.WHAT,
        Config::TOML::Parser::Grammar,
        q:to/EOF/
        ♪ [Grammar.parse($toml-c, :$actions)] - 3 of 14
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Parses TOML with dotted keys successfully
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match-toml-d.WHAT,
        Config::TOML::Parser::Grammar,
        q:to/EOF/
        ♪ [Grammar.parse($toml-d, :$actions)] - 4 of 14
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Parses TOML with dotted keys successfully
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match-toml-e.WHAT,
        Config::TOML::Parser::Grammar,
        q:to/EOF/
        ♪ [Grammar.parse($toml-e, :$actions)] - 5 of 14
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Parses TOML with dotted keys successfully
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match-toml-f.WHAT,
        Config::TOML::Parser::Grammar,
        q:to/EOF/
        ♪ [Grammar.parse($toml-f, :$actions)] - 6 of 14
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Parses TOML with dotted keys successfully
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match-toml-g.WHAT,
        Config::TOML::Parser::Grammar,
        q:to/EOF/
        ♪ [Grammar.parse($toml-g, :$actions)] - 7 of 14
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Parses TOML with dotted keys successfully
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match-toml-a.made<a>[0]<b><c><d>,
        123,
        q:to/EOF/
        ♪ [Is expected value?] - 8 of 14
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ $match-toml-a.made<a>[0]<b><c><d> == 123
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match-toml-b.made<a>[0]<b><c><d>,
        123,
        q:to/EOF/
        ♪ [Is expected value?] - 9 of 14
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ $match-toml-b.made<a>[0]<b><c><d> == 123
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match-toml-c.made<a>[0]<b><c><d>,
        123,
        q:to/EOF/
        ♪ [Is expected value?] - 10 of 14
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ $match-toml-c.made<a>[0]<b><c><d> == 123
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match-toml-d.made<a>[0]<b><c><d>,
        123,
        q:to/EOF/
        ♪ [Is expected value?] - 11 of 14
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ $match-toml-d.made<a>[0]<b><c><d> == 123
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match-toml-e.made<a>[0]<b><c><d>,
        123,
        q:to/EOF/
        ♪ [Is expected value?] - 12 of 14
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ $match-toml-e.made<a>[0]<b><c><d> == 123
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match-toml-f.made<a>[0]<b><c><d>,
        123,
        q:to/EOF/
        ♪ [Is expected value?] - 13 of 14
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ $match-toml-f.made<a>[0]<b><c><d> == 123
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match-toml-g.made<a>[0]<b><c><d>,
        123,
        q:to/EOF/
        ♪ [Is expected value?] - 14 of 14
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ $match-toml-g.made<a>[0]<b><c><d> == 123
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
});

# vim: set filetype=perl6 foldmethod=marker foldlevel=0:
