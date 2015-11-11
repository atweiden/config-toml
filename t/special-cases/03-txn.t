use v6;
use lib 'lib';
use Test;
use Config::TOML::Parser::Actions;
use Config::TOML::Parser::Grammar;

plan 1;

subtest
{
    my Str $toml = slurp 't/data/sample.transactions.toml';
    my Config::TOML::Parser::Actions $actions .= new;
    my $match_toml = Config::TOML::Parser::Grammar.parse($toml, :$actions);

    is(
        $match_toml.WHAT,
        Match,
        q:to/EOF/
        ♪ [Grammar.parse($toml, :$actions)] - 1 of 19
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Parses TOML document successfully
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match_toml.made<Entry>[0]<Header><date>.Date,
        Date.new("2014-01-01"),
        q:to/EOF/
        ♪ [Is expected value?] - 2 of 19
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ $match_toml.made<Entry>[0]<Header><date>.Date
        ┃   Success   ┃        ~~ Date.new("2014-01-01")
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match_toml.made<Entry>[0]<Header><description>,
        'I started the year with $1000 in Bankwest cheque account',
        q:to/EOF/
        ♪ [Is expected value?] - 3 of 19
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ $match_toml.made<Entry>[0]<Header><description>
        ┃   Success   ┃        ~~ '...'
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match_toml.made<Entry>[0]<Header><importance>,
        0,
        q:to/EOF/
        ♪ [Is expected value?] - 4 of 19
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ $match_toml.made<Entry>[0]<Header><importance>
        ┃   Success   ┃        == 0
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match_toml.made<Entry>[0]<Header><tags>,
        [ 'TAG1', 'TAG2' ],
        q:to/EOF/
        ♪ [Is expected value?] - 5 of 19
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ $match_toml.made<Entry>[0]<Header><tags>
        ┃   Success   ┃        ~~ [ 'TAG1', 'TAG2' ]
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match_toml.made<Entry>[0]<Posting>[0]<Account><silo>,
        'ASSETS',
        q:to/EOF/
        ♪ [Is expected value?] - 6 of 19
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ $match_toml.made<Entry>[0]<Posting>[0]<Account><silo>
        ┃   Success   ┃        ~~ 'ASSETS'
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match_toml.made<Entry>[0]<Posting>[0]<Account><entity>,
        'Personal',
        q:to/EOF/
        ♪ [Is expected value?] - 7 of 19
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ $match_toml.made<Entry>[0]<Posting>[0]<Account><entity>
        ┃   Success   ┃        ~~ 'Personal'
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match_toml.made<Entry>[0]<Posting>[0]<Account><subaccount>,
        [ 'Bankwest', 'Cheque' ],
        q:to/EOF/
        ♪ [Is expected value?] - 8 of 19
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ $match_toml.made<Entry>[0]<Posting>[0]<Account><subaccount>
        ┃   Success   ┃        ~~ [ 'Bankwest', 'Cheque' ]
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match_toml.made<Entry>[0]<Posting>[0]<Amount><asset_code>,
        'USD',
        q:to/EOF/
        ♪ [Is expected value?] - 9 of 19
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ $match_toml.made<Entry>[0]<Posting>[0]<Amount><asset_code>
        ┃   Success   ┃        ~~ 'USD'
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match_toml.made<Entry>[0]<Posting>[0]<Amount><asset_quantity>,
        1000.00,
        q:to/EOF/
        ♪ [Is expected value?] - 10 of 19
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ $match_toml.made<Entry>[0]<Posting>[0]<Amount><asset_quantity>
        ┃   Success   ┃        == 1000.00
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match_toml.made<Entry>[0]<Posting>[0]<Amount><asset_symbol>,
        '$',
        q:to/EOF/
        ♪ [Is expected value?] - 11 of 19
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ $match_toml.made<Entry>[0]<Posting>[0]<Amount><asset_symbol>
        ┃   Success   ┃        ~~ '$'
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match_toml.made<Entry>[0]<Posting>[0]<Amount><plus_or_minus>,
        '',
        q:to/EOF/
        ♪ [Is expected value?] - 12 of 19
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ $match_toml.made<Entry>[0]<Posting>[0]<Amount><plus_or_minus>
        ┃   Success   ┃        ~~ ''
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match_toml.made<Entry>[0]<Posting>[1]<Account><silo>,
        'EQUITY',
        q:to/EOF/
        ♪ [Is expected value?] - 13 of 19
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ $match_toml.made<Entry>[0]<Posting>[1]<Account><silo>
        ┃   Success   ┃        ~~ 'EQUITY'
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match_toml.made<Entry>[0]<Posting>[1]<Account><entity>,
        'Personal',
        q:to/EOF/
        ♪ [Is expected value?] - 14 of 19
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ $match_toml.made<Entry>[0]<Posting>[1]<Account><entity>
        ┃   Success   ┃        ~~ 'Personal'
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match_toml.made<Entry>[0]<Posting>[1]<Account><subaccount>,
        [],
        q:to/EOF/
        ♪ [Is expected value?] - 15 of 19
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ $match_toml.made<Entry>[0]<Posting>[1]<Account><subaccount>
        ┃   Success   ┃        ~~ []
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match_toml.made<Entry>[0]<Posting>[1]<Amount><asset_code>,
        'USD',
        q:to/EOF/
        ♪ [Is expected value?] - 16 of 19
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ $match_toml.made<Entry>[0]<Posting>[1]<Amount><asset_code>
        ┃   Success   ┃        ~~ 'USD'
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match_toml.made<Entry>[0]<Posting>[1]<Amount><asset_quantity>,
        1000.00,
        q:to/EOF/
        ♪ [Is expected value?] - 17 of 19
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ $match_toml.made<Entry>[0]<Posting>[1]<Amount><asset_quantity>
        ┃   Success   ┃        == 1000.00
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match_toml.made<Entry>[0]<Posting>[1]<Amount><asset_symbol>,
        '$',
        q:to/EOF/
        ♪ [Is expected value?] - 18 of 19
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ $match_toml.made<Entry>[0]<Posting>[1]<Amount><asset_symbol>
        ┃   Success   ┃        ~~ '$'
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match_toml.made<Entry>[0]<Posting>[1]<Amount><plus_or_minus>,
        '',
        q:to/EOF/
        ♪ [Is expected value?] - 19 of 19
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ $match_toml.made<Entry>[0]<Posting>[1]<Amount><plus_or_minus>
        ┃   Success   ┃        ~~ ''
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
}

# vim: ft=perl6
