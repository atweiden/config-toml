use v6;
use lib 'lib';
use Test;
use Config::TOML::Parser::Actions;
use Config::TOML::Parser::Grammar;

plan 3;

# document grammar tests {{{

# subtest
{
    my Str $document = slurp 't/data/example-v0.4.0.toml';
    my Str $document_hard = slurp 't/data/hard_example.toml';
    my Str $document_standard = slurp 't/data/example.toml';

    my Config::TOML::Parser::Actions $actions .= new;
    my $match_document = Config::TOML::Parser::Grammar.parse(
        $document,
        :$actions
    );
    say 'EXAMPLE v0.4.0';
    say $match_document.made.perl;
    say 'END EXAMPLE v0.4.0';

    my Config::TOML::Parser::Actions $actions_hard .= new;
    my $match_document_hard = Config::TOML::Parser::Grammar.parse(
        $document_hard,
        :actions($actions_hard)
    );
    say 'EXAMPLE HARD';
    say $match_document_hard.made.perl;
    say 'END EXAMPLE HARD';

    my Config::TOML::Parser::Actions $actions_standard .= new;
    my $match_document_standard = Config::TOML::Parser::Grammar.parse(
        $document_standard,
        :actions($actions_standard)
    );
    say 'EXAMPLE STANDARD';
    say $match_document_standard.made.perl;
    say 'END EXAMPLE STANDARD';

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
    is(
        $match_document_hard.WHAT,
        Match,
        q:to/EOF/
        ♪ [Grammar.parse($document_hard)] - 1 of 1
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Parses TOML v0.4.0 document successfully
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match_document_standard.WHAT,
        Match,
        q:to/EOF/
        ♪ [Grammar.parse($document_standard)] - 1 of 1
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
