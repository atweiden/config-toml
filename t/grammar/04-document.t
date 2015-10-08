use v6;
use lib 'lib';
use Test;
use Config::TOML::Parser::Grammar;

plan 1;

# document grammar tests {{{

# subtest
{
    my Str $document = slurp 't/data/example-v0.4.0.toml';

    my $match_document = Config::TOML::Parser::Grammar.parse(
        $document
    );

    is(
        $match_document.WHAT,
        Match,
        q:to/EOF/
        ♪ [Grammar.parse($document)] - 1 of 1
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Parses TOML v0.4.0 document successfully
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
}

# end table grammar tests }}}

# vim: ft=perl6 fdm=marker fdl=0
