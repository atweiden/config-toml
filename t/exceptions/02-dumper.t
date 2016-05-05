use v6;
use lib 'lib';
use Config::TOML;
use Test;

plan 2;

# check keys for validity
subtest
{
    my Int %g{Buf} = Buf.new => 1;
    throws-like {to-toml(%g)}, X::Config::TOML::Dumper::BadKey,
        :message('Sorry, Buf types cannot be represented as TOML keypair key'),
        'Raise exception when key is not of type Str';

    my Int %h{List} = qw<a b c> => 1;
    throws-like {to-toml(%h)}, X::Config::TOML::Dumper::BadKey,
        :message('Sorry, List types cannot be represented as TOML keypair key'),
        'Raise exception when key is not of type Str';

    my WhateverCode $wecode = *-1;
    my Int %i{WhateverCode} = $wecode => -1;
    throws-like {to-toml(%i)}, X::Config::TOML::Dumper::BadKey,
        :message(
            'Sorry, WhateverCode types cannot be represented as TOML keypair key'
        ),
        'Raise exception when key is not of type Str';
}

# check values for validity
subtest
{
    my Any $any = Any;
    my Buf $buf = Buf.new;
    my Complex $complex = 2i;
    my Match $match = Config::TOML::Parser::Grammar.parse("i = 1\n");
    my Range $range = 1..10;
    my Regex $regex = /abc/;
    my Signature $signature = :(@prefix, Bool :$extra-brackets);
    my Version $version = v1.0.0;
    my WhateverCode $wecode = *-1;

    my Any %a = :a($any);
    my Buf %b = :b($buf);
    my Complex %c = :c($complex);
    my Match %d = :d($match);
    my Range %e = :e($range);
    my Regex %f = :f($regex);
    my Signature %g = :g($signature);
    my Version %h = :h($version);
    my WhateverCode %i = :i($wecode);

    throws-like {to-toml(%a)}, X::Config::TOML::Dumper::BadValue,
        :message(
            'Sorry, Any types cannot be represented as TOML keypair value'
        ),
        'Raise exception when value is invalid';
    throws-like {to-toml(%b)}, X::Config::TOML::Dumper::BadValue,
        :message(
            'Sorry, Buf types cannot be represented as TOML keypair value'
        ),
        'Raise exception when value is invalid';
    throws-like {to-toml(%c)}, X::Config::TOML::Dumper::BadValue,
        :message(
            'Sorry, Complex types cannot be represented as TOML keypair value'
        ),
        'Raise exception when value is invalid';
    throws-like {to-toml(%d)}, X::Config::TOML::Dumper::BadValue,
        :message(
            'Sorry, Match types cannot be represented as TOML keypair value'
        ),
        'Raise exception when value is invalid';
    throws-like {to-toml(%e)}, X::Config::TOML::Dumper::BadValue,
        :message(
            'Sorry, Range types cannot be represented as TOML keypair value'
        ),
        'Raise exception when value is invalid';
    throws-like {to-toml(%f)}, X::Config::TOML::Dumper::BadValue,
        :message(
            'Sorry, Regex types cannot be represented as TOML keypair value'
        ),
        'Raise exception when value is invalid';
    throws-like {to-toml(%g)}, X::Config::TOML::Dumper::BadValue,
        :message(
            'Sorry, Signature types cannot be represented as TOML keypair value'
        ),
        'Raise exception when value is invalid';
    throws-like {to-toml(%h)}, X::Config::TOML::Dumper::BadValue,
        :message(
            'Sorry, Version types cannot be represented as TOML keypair value'
        ),
        'Raise exception when value is invalid';
    throws-like {to-toml(%i)}, X::Config::TOML::Dumper::BadValue,
        :message(
            'Sorry, WhateverCode types cannot be represented as TOML keypair value'
        ),
        'Raise exception when value is invalid';
}

# vim: ft=perl6 fdm=marker fdl=0 nowrap
