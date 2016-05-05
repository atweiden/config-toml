use v6;
use Config::TOML::Parser::Grammar;
use X::Config::TOML;
unit class Config::TOML::Dumper;

has Str $!toml = '';

method dump(%h) returns Str
{
    self!visit(%h);
    $!toml.trim;
}

# credit: https://github.com/emancu/toml-rb
method !visit(%h, :@prefix, Bool :$extra-brackets)
{
    my List ($simple-pairs, $nested-pairs, $table-array-pairs) = sort-pairs(%h);

    self!print-prefix(@prefix, :$extra-brackets)
        if @prefix && ($simple-pairs || %h.elems == 0);

    self!dump-pairs(
        :$simple-pairs,
        :$nested-pairs,
        :$table-array-pairs,
        :@prefix
    );
}

sub sort-pairs(%h) returns List
{
    my Hash (@simple-pairs, @nested-pairs, @table-array-pairs);

    for %h.kv -> $key, $val
    {
        unless is-valid-key($key)
        {
            die X::Config::TOML::Dumper::BadKey.new(:$key);
        }

        if $val ~~ Associative
        {
            @nested-pairs.unshift: %($key => $val);
        }
        elsif $val ~~ List && $val[0] ~~ Associative
        {
            @table-array-pairs.unshift: %($key => $val);
        }
        else
        {
            @simple-pairs.unshift: %($key => $val);
        }
    }

    @simple-pairs .= sort;
    @nested-pairs .= sort;
    @table-array-pairs .= sort;

    (@simple-pairs, @nested-pairs, @table-array-pairs);
}

method !dump-pairs(
    Hash :@simple-pairs!,
    Hash :@nested-pairs!,
    Hash :@table-array-pairs!,
    :@prefix = ()
)
{
    self!dump-simple-pairs(@simple-pairs);
    self!dump-nested-pairs(@nested-pairs, @prefix);
    self!dump-table-array-pairs(@table-array-pairs, @prefix);
}


method !dump-simple-pairs(Hash @simple-pairs)
{
    @simple-pairs.map({
        my Str $key = is-bare-key(.keys[0]) ?? .keys[0] !! .keys[0].perl;
        $!toml ~= "$key = {to-toml(.values[0])}\n";
    });
}

method !dump-nested-pairs(Hash @nested-pairs, @prefix)
{
    @nested-pairs.map({
        my Str $key = is-bare-key(.keys[0]) ?? .keys[0] !! .keys[0].perl;
        self!visit(.values[0], :prefix(|@prefix, $key), :!extra-brackets);
    });
}

method !dump-table-array-pairs(Hash @table-array-pairs, @prefix)
{
    for @table-array-pairs -> %table-array-pair
    {
        my Str $key = is-bare-key(%table-array-pair.keys[0])
            ?? %table-array-pair.keys[0]
            !! %table-array-pair.keys[0].perl;

        my @aux-prefix = |@prefix, $key;

        for %table-array-pair.values[0].flat -> %p
        {
            self!print-prefix(@aux-prefix, :extra-brackets);
            my List ($simple-pairs, $nested-pairs, $table-array-pairs) =
                sort-pairs(%p);
            self!dump-pairs(
                :$simple-pairs,
                :$nested-pairs,
                :$table-array-pairs,
                :prefix(@aux-prefix)
            );
        }
    }
}

method !print-prefix(@prefix, Bool :$extra-brackets)
{
    my Str $new-prefix = @prefix.join('.');
    $new-prefix = '[' ~ $new-prefix ~ ']' if $extra-brackets;
    $!toml ~= '[' ~ $new-prefix ~ "]\n";
}

sub is-bare-key($key) returns Bool
{
    Config::TOML::Parser::Grammar.parse($key, :rule<keypair-key:bare>).so;
}

sub is-valid-key($key) returns Bool
{
    $key.isa(Str)
        && Config::TOML::Parser::Grammar.parse($key, :rule<keypair-key>).so;
}

multi sub to-toml(Str $s) returns Str
{
    $s.perl;
}

multi sub to-toml(Real $r) returns Str
{
    ~$r;
}

multi sub to-toml(Bool $b) returns Str
{
    ~$b;
}

multi sub to-toml(Dateish $d) returns Str
{
    ~$d;
}

multi sub to-toml(Associative $a) returns Str
{
    my Str @keypairs;
    $a.map({
        push @keypairs,
            is-bare-key(.key) ?? .key !! .key.perl
            ~ ' = '
            ~ to-toml(.value)
    });
    '{ ' ~ @keypairs.join(', ') ~ ' }';
}

multi sub to-toml(List $l) returns Str
{
    my Str @elements;
    $l.map({ push @elements, to-toml($_) });
    '[ ' ~ @elements.join(', ') ~ ' ]';
}

multi sub to-toml($value)
{
    die X::Config::TOML::Dumper::BadValue.new(:$value);
}

# vim: ft=perl6 fdm=marker fdl=0 nowrap
