use v6;
use Config::TOML::Parser;
unit module Config::TOML;

sub from-toml($text) is export
{
    Config::TOML::Parser.parse($text).made;
}

# vim: ft=perl6
