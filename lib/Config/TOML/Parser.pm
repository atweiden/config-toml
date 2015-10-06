use v6;
use Config::TOML::Parser::Actions;
use Config::TOML::Parser::Grammar;
unit class Config::TOML::Parser;

method parse(Str:D $content, *%opts) returns Match
{
    my Config::TOML::Parser::Actions $actions .= new;
    Config::TOML::Parser::Grammar.parse($content, :$actions, |%opts);
}

# vim: ft=perl6
