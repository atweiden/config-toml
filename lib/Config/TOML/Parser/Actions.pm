use v6;
unit class Config::TOML::Parser::Actions;

# string grammar-actions {{{

# --- string basic grammar-actions {{{

method string_basic_char:common ($/)
{
    make ~$/;
}

method string_basic_char:tab ($/)
{
    make ~$/;
}

method escape:sym<b>($/)
{
    make "\b";
}

method escape:sym<t>($/)
{
    make "\t";
}

method escape:sym<n>($/)
{
    make "\n";
}

method escape:sym<f>($/)
{
    make "\f";
}

method escape:sym<r>($/)
{
    make "\r";
}

method escape:sym<quote>($/)
{
    make "\"";
}

method escape:sym<backslash>($/)
{
    make '\\';
}

method escape:sym<u>($/)
{
    make chr :16(@<hex>.join);
}

method escape:sym<U>($/)
{
    make chr :16(@<hex>.join);
}

method string_basic_char:escape_sequence ($/)
{
    make $<escape>.made;
}

method string_basic_text($/)
{
    make @<string_basic_char>».made.join;
}

method string_basic($/)
{
    make $<string_basic_text> ?? $<string_basic_text>.made !! "";
}

method string_basic_multiline_char:common ($/)
{
    make ~$/;
}

method string_basic_multiline_char:tab ($/)
{
    make ~$/;
}

method string_basic_multiline_char:newline ($/)
{
    make ~$/;
}

method string_basic_multiline_char:escape_sequence ($/)
{
    if $<escape>
    {
        make $<escape>.made;
    }
    elsif $<ws_remover>
    {
        make "";
    }
}

method string_basic_multiline_text($/)
{
    make @<string_basic_multiline_char>».made.join;
}

method string_basic_multiline($/)
{
    make $<string_basic_multiline_text>
        ?? $<string_basic_multiline_text>.made
        !! "";
}

# --- end string basic grammar-actions }}}
# --- string literal grammar-actions {{{

method string_literal_char:common ($/)
{
    make ~$/;
}

method string_literal_char:backslash ($/)
{
    make '\\';
}

method string_literal_text($/)
{
    make @<string_literal_char>».made.join;
}

method string_literal($/)
{
    make $<string_literal_text> ?? $<string_literal_text>.made !! "";
}

method string_literal_multiline_char:common ($/)
{
    make ~$/;
}

method string_literal_multiline_char:backslash ($/)
{
    make '\\';
}

method string_literal_multiline_text($/)
{
    make @<string_literal_multiline_char>».made.join;
}

method string_literal_multiline($/)
{
    make $<string_literal_multiline_text>
        ?? $<string_literal_multiline_text>.made
        !! "";
}

# --- end string literal grammar-actions }}}

method string($/)
{
    if $<string_basic_multiline>
    {
        make $<string_basic_multiline>.made;
    }
    elsif $<string_basic>
    {
        make $<string_basic>.made;
    }
    elsif $<string_literal_multiline>
    {
        make $<string_literal_multiline>.made;
    }
    elsif $<string_literal>
    {
        make $<string_literal>.made;
    }
}

# end string grammar-actions }}}
# number grammar-actions {{{

method integer($/)
{
    make Int(+$/);
}

method float($/)
{
    make +$/;
}

method number($/)
{
    if $<integer>
    {
        make $<integer>.made;
    }
    elsif $<float>
    {
        make $<float>.made;
    }
}

# end number grammar-actions }}}
# boolean grammar-actions {{{

method boolean:sym<true>($/)
{
    make True;
}

method boolean:sym<false>($/)
{
    make False;
}

# end boolean grammar-actions }}}
# datetime grammar-actions {{{

method date_fullyear($/)
{
    make Int(+$/);
}

method date_month($/)
{
    make Int(+$/);
}

method date_mday($/)
{
    make Int(+$/);
}

method time_hour($/)
{
    make Int(+$/);
}

method time_minute($/)
{
    make Int(+$/);
}

method time_second($/)
{
    make Rat(+$/);
}

method time_secfrac($/)
{
    make Rat(+$/);
}

method time_numoffset($/)
{
    my Int $multiplier = $<plus_or_minus> ~~ '+' ?? 1 !! -1;
    make Int(
        (
            ($multiplier * $<time_hour>.made * 60) + $<time_minute>.made
        )
        * 60
    );
}

method time_offset($/)
{
    make $<time_numoffset> ?? Int($<time_numoffset>.made) !! 0;
}

method partial_time($/)
{
    my Rat $second = Rat($<time_second>.made);
    my Bool $subseconds = False;

    if $<time_secfrac>
    {
        $second += Rat($<time_secfrac>.made);
        $subseconds = True;
    }

    make %(
        :hour(Int($<time_hour>.made)),
        :minute(Int($<time_minute>.made)),
        :$second,
        :$subseconds
    );
}

method full_date($/)
{
    make %(
        :year(Int($<date_fullyear>.made)),
        :month(Int($<date_month>.made)),
        :day(Int($<date_mday>.made))
    );
}

method full_time($/)
{
    make %(
        :hour(Int($<partial_time>.made<hour>)),
        :minute(Int($<partial_time>.made<minute>)),
        :second(Rat($<partial_time>.made<second>)),
        :subseconds(Bool($<partial_time>.made<subseconds>)),
        :timezone(Int($<time_offset>.made))
    );
}

method date_time($/)
{
    my %fmt;
    %fmt<formatter> =
        {
            # adapted from rakudo/src/core/Temporal.pm
            # needed in place of passing a True :$subseconds arg to
            # the rakudo DateTime default-formatter subroutine
            # for DateTimes with defined time_secfrac
            my $o = .offset;
            $o %% 60
                or warn "DateTime subseconds formatter: offset $o not
                         divisible by 60.";
            my $year = sprintf(
                (0 <= .year <= 9999 ?? '%04d' !! '%+05d'),
                .year
            );
            sprintf '%s-%02d-%02dT%02d:%02d:%s%s',
                $year, .month, .day, .hour, .minute,
                .second.fmt('%09.6f'),
                do $o
                    ?? sprintf '%s%02d:%02d',
                        $o < 0 ?? '-' !! '+',
                        ($o.abs / 60 / 60).floor,
                        ($o.abs / 60 % 60).floor
                    !! 'Z';
        } if $<full_time>.made<subseconds>;

    make DateTime.new(
        :year(Int($<full_date>.made<year>)),
        :month(Int($<full_date>.made<month>)),
        :day(Int($<full_date>.made<day>)),
        :hour(Int($<full_time>.made<hour>)),
        :minute(Int($<full_time>.made<minute>)),
        :second(Rat($<full_time>.made<second>)),
        :timezone(Int($<full_time>.made<timezone>)),
        |%fmt
    );
}

# end datetime grammar-actions }}}
# array grammar-actions {{{

method array_elements:strings ($/)
{
    make @<string>».made;
}

method array_elements:integers ($/)
{
    make @<integer>».made;
}

method array_elements:floats ($/)
{
    make @<float>».made;
}

method array_elements:booleans ($/)
{
    make @<boolean>».made;
}

method array_elements:date_times ($/)
{
    make @<date_time>».made;
}

method array_elements:arrays ($/)
{
    make @<array>».made;
}

method array_elements:table_inlines ($/)
{
    make @<table_inline>».made;
}

method array($/)
{
    make $<array_elements> ?? $<array_elements>.made !! Array;
}

# end array grammar-actions }}}
# table grammar-actions {{{

method keypair_key:bare ($/)
{
    make ~$/;
}

method keypair_key:quoted ($/)
{
    make $<string_basic>.made;
}

method keypair_value:string ($/)
{
    make $<string>.made;
}

method keypair_value:number ($/)
{
    make $<number>.made;
}

method keypair_value:boolean ($/)
{
    make $<boolean>.made;
}

method keypair_value:date_time ($/)
{
    make $<date_time>.made;
}

method keypair_value:array ($/)
{
    make $<array>.made;
}

method keypair_value:table_inline ($/)
{
    make $<table_inline>.made;
}

method keypair($/)
{
    make Str($<keypair_key>.made) => $<keypair_value>.made;
}

method table_inline_keypairs($/)
{
    make @<keypair>».made;
}

method table_inline($/)
{
    make $<table_inline_keypairs>
        ?? $<table_inline_keypairs>.made
        !! Array[Hash];
}

# end table grammar-actions }}}

# vim: ft=perl6 fdm=marker fdl=0
