use v6;
use lib 'lib';
use Test;
use Config::TOML::Parser::Actions;
use Config::TOML::Parser::Grammar;

plan 14;

subtest
{
    my Str $toml = Q:to/EOF/;
    # DO NOT DO THIS
    a = { b = 1, b = 2, c = 3 }
    EOF

    my Config::TOML::Parser::Actions $actions .= new;
    throws-like(
        {Config::TOML::Parser::Grammar.parse($toml, :$actions)},
        X::Config::TOML::InlineTable::DuplicateKeys,
        q:to/EOF/
        ♪ [Grammar.parse($toml, :$actions)] - 1 of 14
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Throws exception
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
}

subtest
{
    my Str $toml = Q:to/EOF/;
    # DO NOT DO THIS
    [a]
    b = 1
    b = 2
    EOF

    my Config::TOML::Parser::Actions $actions .= new;
    throws-like(
        {Config::TOML::Parser::Grammar.parse($toml, :$actions)},
        X::Config::TOML::Keypath::HOH,
        q:to/EOF/
        ♪ [Grammar.parse($toml, :$actions)] - 2 of 14
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Throws exception
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
}

subtest
{
    my Str $toml = Q:to/EOF/;
    # DO NOT DO THIS
    [a]
    b = 1

    [a]
    c = 2
    EOF

    my Config::TOML::Parser::Actions $actions .= new;
    throws-like(
        {Config::TOML::Parser::Grammar.parse($toml, :$actions)},
        X::Config::TOML::HOH::Seen,
        q:to/EOF/
        ♪ [Grammar.parse($toml, :$actions)] - 3 of 14
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Throws exception
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
}

subtest
{
    my Str $toml = Q:to/EOF/;
    # DO NOT DO THIS
    [a]
    [a]
    EOF

    my Config::TOML::Parser::Actions $actions .= new;
    throws-like(
        {Config::TOML::Parser::Grammar.parse($toml, :$actions)},
        X::Config::TOML::HOH::Seen,
        q:to/EOF/
        ♪ [Grammar.parse($toml, :$actions)] - 4 of 14
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Throws exception
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
}

subtest
{
    my Str $toml = Q:to/EOF/;
    # DO NOT DO THIS
    [a.b]
    c = 1

    [[a]]
    b = 2
    EOF

    my Config::TOML::Parser::Actions $actions .= new;
    throws-like(
        {Config::TOML::Parser::Grammar.parse($toml, :$actions)},
        X::Config::TOML::AOH::OverwritesHOH,
        q:to/EOF/
        ♪ [Grammar.parse($toml, :$actions)] - 5 of 14
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Throws exception
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
}

subtest
{
    my Str $toml = Q:to/EOF/;
    # DO NOT DO THIS
    [a]
    [[a]]
    EOF

    my Config::TOML::Parser::Actions $actions .= new;
    throws-like(
        {Config::TOML::Parser::Grammar.parse($toml, :$actions)},
        X::Config::TOML::AOH::OverwritesHOH,
        q:to/EOF/
        ♪ [Grammar.parse($toml, :$actions)] - 6 of 14
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Throws exception
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
}

subtest
{
    my Str $toml = Q:to/EOF/;
    # DO NOT DO THIS
    [[a]]
    b = 1

    [a]
    c = 2
    EOF

    my Config::TOML::Parser::Actions $actions .= new;
    throws-like(
        {Config::TOML::Parser::Grammar.parse($toml, :$actions)},
        X::Config::TOML::HOH::Seen::AOH,
        q:to/EOF/
        ♪ [Grammar.parse($toml, :$actions)] - 7 of 14
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Throws exception
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
}

subtest
{
    my Str $toml = Q:to/EOF/;
    # DO NOT DO THIS
    [[a]]
    [a]
    EOF

    my Config::TOML::Parser::Actions $actions .= new;
    throws-like(
        {Config::TOML::Parser::Grammar.parse($toml, :$actions)},
        X::Config::TOML::HOH::Seen::AOH,
        q:to/EOF/
        ♪ [Grammar.parse($toml, :$actions)] - 8 of 14
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Throws exception
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
}

subtest
{
    my Str $toml = Q:to/EOF/;
    # DO NOT DO THIS
    [fruit]
    type = "apple"

    [fruit.type]
    apple = "yes"
    EOF

    my Config::TOML::Parser::Actions $actions .= new;
    throws-like(
        {Config::TOML::Parser::Grammar.parse($toml, :$actions)},
        X::Config::TOML::Keypath::HOH,
        q:to/EOF/
        ♪ [Grammar.parse($toml, :$actions)] - 9 of 14
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Throws exception
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
}

subtest
{
    my Str $toml = Q:to/EOF/;
    # DO NOT DO THIS
    a = 2
    a = 3
    EOF

    my Config::TOML::Parser::Actions $actions .= new;
    throws-like(
        {Config::TOML::Parser::Grammar.parse($toml, :$actions)},
        X::Config::TOML::KeypairLine::DuplicateKeys,
        q:to/EOF/
        ♪ [Grammar.parse($toml, :$actions)] - 10 of 14
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Throws exception
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
}

subtest
{
    my Str $toml = Q:to/EOF/;
    # DO NOT DO THIS
    [a]
    b = 1
    b = 2
    EOF

    my Config::TOML::Parser::Actions $actions .= new;
    throws-like(
        {Config::TOML::Parser::Grammar.parse($toml, :$actions)},
        X::Config::TOML::Keypath::HOH,
        q:to/EOF/
        ♪ [Grammar.parse($toml, :$actions)] - 11 of 14
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Throws exception
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
}

subtest
{
    my Str $toml = Q:to/EOF/;
    # DO NOT DO THIS
    a = 1

    [a]
    c = 2
    EOF

    my Config::TOML::Parser::Actions $actions .= new;
    throws-like(
        {Config::TOML::Parser::Grammar.parse($toml, :$actions)},
        X::Config::TOML::Keypath::HOH,
        q:to/EOF/
        ♪ [Grammar.parse($toml, :$actions)] - 12 of 14
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Throws exception
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
}

subtest
{
    my Str $toml = Q:to/EOF/;
    # DO NOT DO THIS
    a = 1

    [a.b]
    c = 2
    EOF

    my Config::TOML::Parser::Actions $actions .= new;
    throws-like(
        {Config::TOML::Parser::Grammar.parse($toml, :$actions)},
        X::Config::TOML::Keypath::HOH,
        q:to/EOF/
        ♪ [Grammar.parse($toml, :$actions)] - 13 of 14
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Throws exception
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
}

subtest
{
    my Str $toml = Q:to/EOF/;
    # DO NOT DO THIS
    a = { b = 1  }

    [a.b]
    c = 2
    EOF

    my Config::TOML::Parser::Actions $actions .= new;
    throws-like(
        {Config::TOML::Parser::Grammar.parse($toml, :$actions)},
        X::Config::TOML::Keypath::HOH,
        q:to/EOF/
        ♪ [Grammar.parse($toml, :$actions)] - 14 of 14
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Throws exception
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
}

=begin pod

=comment
Commented out as it's unclear from TOML spec whether these examples are
valid or invalid.

=begin code

    subtest
    {
        my Str $toml = Q:to/EOF/;
        # ???
        [header1]
        header1key1 = { inlinetablekey1 = 1, inlinetablekey2 = 2 }

        [header1.header1key1]
        number = 9
        EOF

        $toml = Q:to/EOF/;
        # ???
        a = [ { a = 1, b = 2, c = 3 }, { d = 4, e = 5, f = 6 } ]
        [[a]]
        g = 7
        h = 8
        i = 9
        EOF

        $toml = Q:to/EOF/;
        # ???
        a = { b = 1  }
        [a]
        c = 2
        EOF

        my Config::TOML::Parser::Actions $actions .= new;
        throws-like(
            {Config::TOML::Parser::Grammar.parse($toml, :$actions)},
            X::Config::TOML::Keypath::HOH,
            q:to/EOF/
            ♪ [Grammar.parse($toml, :$actions)] - 1 of X
            ┏━━━━━━━━━━━━━┓
            ┃             ┃  ∙ Throws exception
            ┃   Success   ┃
            ┃             ┃
            ┗━━━━━━━━━━━━━┛
            EOF
        );
    }

=end code
=end pod

# vim: ft=perl6
