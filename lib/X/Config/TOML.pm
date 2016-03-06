use v6;
unit module X::Config::TOML;

# X::Config::TOML::AOH::DuplicateKeys {{{

class AOH::DuplicateKeys is Exception
{
    has Str $.aoh-text;
    has @.keys-seen;

    method message()
    {
        say "Sorry, arraytable contains duplicate keys.";
        print '-' x 72, "\n";
        say "Array table:";
        say $.aoh-text;
        print '-' x 72, "\n";
        say "Keys seen:";
        .say for @.keys-seen.sort».subst(
            /(.*)/,
            -> $/
            {
                state Int $i = 1;
                my Str $replacement = "$i.「$0」";
                $i++;
                $replacement;
            }
        );
        print '-' x 72, "\n";
        say "Keys seen (unique):";
        .say for @.keys-seen.unique.sort».subst(
            /(.*)/,
            -> $/
            {
                state Int $i = 1;
                my Str $replacement = "$i.「$0」";
                $i++;
                $replacement;
            }
        );
    }
}

# end X::Config::TOML::AOH::DuplicateKeys }}}

# X::Config::TOML::HOH::DuplicateKeys {{{

class HOH::DuplicateKeys is Exception
{
    has Str $.hoh-text;
    has @.keys-seen;

    method message()
    {
        say "Sorry, table contains duplicate keys.";
        print '-' x 72, "\n";
        say "Table:";
        say $.hoh-text;
        print '-' x 72, "\n";
        say "Keys seen:";
        .say for @.keys-seen.sort».subst(
            /(.*)/,
            -> $/
            {
                state Int $i = 1;
                my Str $replacement = "$i.「$0」";
                $i++;
                $replacement;
            }
        );
        print '-' x 72, "\n";
        say "Keys seen (unique):";
        .say for @.keys-seen.unique.sort».subst(
            /(.*)/,
            -> $/
            {
                state Int $i = 1;
                my Str $replacement = "$i.「$0」";
                $i++;
                $replacement;
            }
        );
    }
}
# end X::Config::TOML::HOH::DuplicateKeys }}}

# X::Config::TOML::InlineTable::DuplicateKeys {{{

class InlineTable::DuplicateKeys is Exception
{
    has Str $.table-inline-text;
    has @.keys-seen;

    method message()
    {
        say "Sorry, inline table contains duplicate keys.";
        print '-' x 72, "\n";
        say "Inline table:";
        say $.table-inline-text;
        print '-' x 72, "\n";
        say "Keys seen:";
        .say for @.keys-seen.sort».subst(
            /(.*)/,
            -> $/
            {
                state Int $i = 1;
                my Str $replacement = "$i.「$0」";
                $i++;
                $replacement;
            }
        );
        print '-' x 72, "\n";
        say "Keys seen (unique):";
        .say for @.keys-seen.unique.sort».subst(
            /(.*)/,
            -> $/
            {
                state Int $i = 1;
                my Str $replacement = "$i.「$0」";
                $i++;
                $replacement;
            }
        );
    }
}

# end X::Config::TOML::InlineTable::DuplicateKeys }}}

# X::Config::TOML::KeypairLine::DuplicateKeys {{{

class KeypairLine::DuplicateKeys is Exception
{
    has Str $.keypair-line-text;
    has @.path;

    method message()
    {
        say "Sorry, keypair line contains duplicate key.";
        print '-' x 72, "\n";
        say "Keypair line:";
        say $.keypair-line-text;
        print '-' x 72, "\n";
        say "The key at path「{@.path.join(', ')}」 has already been seen";
    }
}

# end X::Config::TOML::KeypairLine::DuplicateKeys }}}

# X::Config::TOML::AOH {{{

class AOH is Exception
{
    has Str $.aoh-text;
    has @.path;

    method message()
    {
        say qq:to/EOF/;
        Sorry, arraytable keypath 「{@.path.join(', ')}」 trodden.

        In arraytable:

        {$.aoh-text}
        EOF
    }
}

# end X::Config::TOML::AOH }}}

# X::Config::TOML::AOH::OverwritesHOH {{{

class AOH::OverwritesHOH is AOH
{
    has Str $.aoh-header-text;

    method message()
    {
        say qq:to/EOF/;
        Sorry, arraytable 「$.aoh-header-text」 has been declared previously
        as regular table in TOML document.

        In arraytable:

        {$.aoh-text}
        EOF
    }
}

# end X::Config::TOML::AOH::OverwritesHOH }}}

# X::Config::TOML::AOH::OverwritesKey {{{

class AOH::OverwritesKey is AOH
{
    has Str $.aoh-header-text;

    method message()
    {
        say qq:to/EOF/;
        Sorry, arraytable 「$.aoh-header-text」 overwrites existing key in
        TOML document.

        In arraytable:

        {$.aoh-text}
        EOF
    }
}

# end X::Config::TOML::AOH::OverwritesKey }}}

# X::Config::TOML::HOH {{{

class HOH is Exception
{
    has Str $.hoh-text;
    has @.path;

    method message()
    {
        say qq:to/EOF/;
        Sorry, table keypath 「{@.path.join(', ')}」 trodden.

        In table:

        {$.hoh-text}
        EOF
    }
}

# end X::Config::TOML::HOH }}}

# X::Config::TOML::HOH::Seen {{{

class HOH::Seen is HOH
{
    has Str $.hoh-header-text;

    method message()
    {
        say qq:to/EOF/;
        Sorry, table 「$.hoh-header-text」 has been declared previously in TOML document.

        In table:

        {$.hoh-text}
        EOF
    }
}

# end X::Config::TOML::HOH::Seen }}}

# X::Config::TOML::HOH::Seen::AOH {{{

class HOH::Seen::AOH is HOH::Seen {*}

# end X::Config::TOML::HOH::Seen::AOH }}}

# X::Config::TOML::HOH::Seen::Key {{{

class HOH::Seen::Key is HOH
{
    method message()
    {
        say qq:to/EOF/;
        Sorry, table keypath 「{@.path.join(', ')}」 overwrites existing key.

        In table:

        {$.hoh-text}
        EOF
    }
}

# end X::Config::TOML::HOH::Seen::Key }}}

# X::Config::TOML::Keypath {{{

class Keypath is Exception
{
    has @.path;

    method message()
    {
        say qq:to/EOF/;
        「{@.path.join(', ')}」
        EOF
    }
}

# end X::Config::TOML::Keypath }}}

# X::Config::TOML::Keypath::AOH {{{

class Keypath::AOH is AOH {*}

# end X::Config::TOML::Keypath::AOH }}}

# X::Config::TOML::Keypath::HOH {{{

class Keypath::HOH is HOH {*}

# end X::Config::TOML::Keypath::HOH }}}

# X::Config::TOML::BadKeypath::ArrayNotAOH {{{

class BadKeypath::ArrayNotAOH is Exception {*}

# end X::Config::TOML::BadKeypath::ArrayNotAOH }}}

# vim: ft=perl6 fdm=marker fdl=0
