use v6;
use Config::TOML::Parser::ParseTree;
use Crane;
use X::Config::TOML;
unit class Config::TOML::Parser::Actions;

# DateTime offset for when the local offset is omitted in TOML dates,
# see: https://github.com/toml-lang/toml#datetime
# if not passed as a parameter during instantiation, use host machine's
# local offset
has Int:D $.date-local-offset = $*TZ;

# string grammar-actions {{{

# --- string basic grammar-actions {{{

method string-basic-char:common ($/ --> Nil)
{
    make(~$/);
}

method string-basic-char:tab ($/ --> Nil)
{
    make(~$/);
}

method escape:sym<b>($/ --> Nil)
{
    make("\b");
}

method escape:sym<t>($/ --> Nil)
{
    make("\t");
}

method escape:sym<n>($/ --> Nil)
{
    make("\n");
}

method escape:sym<f>($/ --> Nil)
{
    make("\f");
}

method escape:sym<r>($/ --> Nil)
{
    make("\r");
}

method escape:sym<quote>($/ --> Nil)
{
    make("\"");
}

method escape:sym<backslash>($/ --> Nil)
{
    make('\\');
}

method escape:sym<u>($/ --> Nil)
{
    make(chr(:16(@<hex>.join)));
}

method escape:sym<U>($/ --> Nil)
{
    make(chr(:16(@<hex>.join)));
}

method string-basic-char:escape-sequence ($/ --> Nil)
{
    make($<escape>.made);
}

method string-basic-text($/ --> Nil)
{
    make(@<string-basic-char>.hyper.map({ .made }).join);
}

multi method string-basic($/ where $<string-basic-text>.so --> Nil)
{
    make($<string-basic-text>.made);
}

multi method string-basic($/ --> Nil)
{
    make('');
}

method string-basic-multiline-char:common ($/ --> Nil)
{
    make(~$/);
}

method string-basic-multiline-char:tab ($/ --> Nil)
{
    make(~$/);
}

method string-basic-multiline-char:newline ($/ --> Nil)
{
    make(~$/);
}

multi method string-basic-multiline-char:escape-sequence (
    $/ where $<escape>.so
    --> Nil
)
{
    make($<escape>.made);
}

multi method string-basic-multiline-char:escape-sequence (
    $/ where $<ws-remover>.so
    --> Nil
)
{
    make('');
}

method string-basic-multiline-text($/ --> Nil)
{
    make(@<string-basic-multiline-char>.hyper.map({ .made }).join);
}

multi method string-basic-multiline(
    $/ where $<string-basic-multiline-text>.so
    --> Nil
)
{
    make($<string-basic-multiline-text>.made);
}

multi method string-basic-multiline($/ --> Nil)
{
    make('');
}

# --- end string basic grammar-actions }}}
# --- string literal grammar-actions {{{

method string-literal-char:common ($/ --> Nil)
{
    make(~$/);
}

method string-literal-char:backslash ($/ --> Nil)
{
    make('\\');
}

method string-literal-text($/ --> Nil)
{
    make(@<string-literal-char>.hyper.map({ .made }).join);
}

multi method string-literal($/ where $<string-literal-text>.so --> Nil)
{
    make($<string-literal-text>.made);
}

multi method string-literal($/ --> Nil)
{
    make('');
}

method string-literal-multiline-char:common ($/ --> Nil)
{
    make(~$/);
}

method string-literal-multiline-char:backslash ($/ --> Nil)
{
    make('\\');
}

method string-literal-multiline-text($/ --> Nil)
{
    make(@<string-literal-multiline-char>.hyper.map({ .made }).join);
}

multi method string-literal-multiline(
    $/ where $<string-literal-multiline-text>.so
    --> Nil
)
{
    make($<string-literal-multiline-text>.made);
}

multi method string-literal-multiline($/ --> Nil)
{
    make('');
}

# --- end string literal grammar-actions }}}

method string:basic ($/ --> Nil)
{
    my Str:D $make = $<string-basic>.made;
    make(TOMLString['Basic'].new(:$make));
}

method string:basic-multi ($/ --> Nil)
{
    my Str:D $make = $<string-basic-multiline>.made;
    make(TOMLString['Basic', 'Multiline'].new(:$make));
}

method string:literal ($/ --> Nil)
{
    my Str:D $make = $<string-literal>.made;
    make(TOMLString['Literal'].new(:$make));
}

method string:literal-multi ($/ --> Nil)
{
    my Str:D $make = $<string-literal-multiline>.made;
    make(TOMLString['Literal', 'Multiline'].new(:$make));
}

# end string grammar-actions }}}
# number grammar-actions {{{

method float($/ --> Nil)
{
    my $make = +$/;
    make(TOMLFloat['Common'].new(:$make));
}

multi method float-inf($/ where $<plus-or-minus>.so --> Nil)
{
    my Int:D $multiplier = $<plus-or-minus>.made eq '+' ?? 1 !! -1;
    my $make = Inf * $multiplier;
    make(TOMLFloat['Inf'].new(:$make));
}

multi method float-inf($/ --> Nil)
{
    my $make = Inf;
    make(TOMLFloat['Inf'].new(:$make));
}

method float-nan($/ --> Nil)
{
    my $make = NaN;
    make(TOMLFloat['NaN'].new(:$make));
}

method integer($/ --> Nil)
{
    my Int:D $make = Int(+$/);
    make(TOMLInteger['Common'].new(:$make));
}

method integer-bin($/ --> Nil)
{
    my Int:D $make = Int(+$/);
    make(TOMLInteger['Binary'].new(:$make));
}

method integer-hex($/ --> Nil)
{
    my Int:D $make = Int(+$/);
    make(TOMLInteger['Hexadecimal'].new(:$make));
}

method integer-oct($/ --> Nil)
{
    my Int:D $make = Int(+$/);
    make(TOMLInteger['Octal'].new(:$make));
}

method plus-or-minus:sym<+>($/ --> Nil)
{
    make(~$/);
}

method plus-or-minus:sym<->($/ --> Nil)
{
    make(~$/);
}

method number:float ($/ --> Nil)
{
    my TOMLFloat['Common'] $make = $<float>.made;
    make(TOMLNumber['Float'].new(:$make));
}

method number:float-inf ($/ --> Nil)
{
    my TOMLFloat['Inf'] $make = $<float-inf>.made;
    make(TOMLNumber['Float'].new(:$make));
}

method number:float-nan ($/ --> Nil)
{
    my TOMLFloat['NaN'] $make = $<float-nan>.made;
    make(TOMLNumber['Float'].new(:$make));
}

method number:integer ($/ --> Nil)
{
    my TOMLInteger['Common'] $make = $<integer>.made;
    make(TOMLNumber['Integer'].new(:$make));
}

method number:integer-bin ($/ --> Nil)
{
    my TOMLInteger['Binary'] $make = $<integer-bin>.made;
    make(TOMLNumber['Integer'].new(:$make));
}

method number:integer-hex ($/ --> Nil)
{
    my TOMLInteger['Hexadecimal'] $make = $<integer-hex>.made;
    make(TOMLNumber['Integer'].new(:$make));
}

method number:integer-oct ($/ --> Nil)
{
    my TOMLInteger['Octal'] $make = $<integer-oct>.made;
    make(TOMLNumber['Integer'].new(:$make));
}

# end number grammar-actions }}}
# boolean grammar-actions {{{

method boolean:sym<true>($/ --> Nil)
{
    my Bool:D $make = True;
    make(TOMLBoolean['True'].new(:$make));
}

method boolean:sym<false>($/ --> Nil)
{
    my Bool:D $make = False;
    make(TOMLBoolean['False'].new(:$make));
}

# end boolean grammar-actions }}}
# datetime grammar-actions {{{

method date-fullyear($/ --> Nil)
{
    make(Int(+$/));
}

method date-month($/ --> Nil)
{
    make(Int(+$/));
}

method date-mday($/ --> Nil)
{
    make(Int(+$/));
}

method time-hour($/ --> Nil)
{
    make(Int(+$/));
}

method time-minute($/ --> Nil)
{
    make(Int(+$/));
}

method time-second($/ --> Nil)
{
    make(Rat(+$/));
}

method time-secfrac($/ --> Nil)
{
    make(Rat(+$/));
}

method time-numoffset($/ --> Nil)
{
    my Int:D $multiplier = $<plus-or-minus>.made eq '+' ?? 1 !! -1;
    make(
        Int((($multiplier * $<time-hour>.made * 60) + $<time-minute>.made) * 60)
    );
}

multi method time-offset($/ where $<time-numoffset>.so --> Nil)
{
    make(Int($<time-numoffset>.made));
}

multi method time-offset($/ --> Nil)
{
    make(0);
}

method partial-time($/ --> Nil)
{
    my Rat:D $second = Rat($<time-second>.made);
    $second += Rat($<time-secfrac>.made) if $<time-secfrac>;
    make(
        %(
            :hour(Int($<time-hour>.made)),
            :minute(Int($<time-minute>.made)),
            :$second
        )
    );
}

method full-date($/ --> Nil)
{
    make(
        %(
            :year(Int($<date-fullyear>.made)),
            :month(Int($<date-month>.made)),
            :day(Int($<date-mday>.made))
        )
    );
}

method full-time($/ --> Nil)
{
    make(
        %(
            :hour(Int($<partial-time>.made<hour>)),
            :minute(Int($<partial-time>.made<minute>)),
            :second(Rat($<partial-time>.made<second>)),
            :timezone(Int($<time-offset>.made))
        )
    );
}

method date-time-omit-local-offset($/ --> Nil)
{
    make(
        %(
            :year(Int($<full-date>.made<year>)),
            :month(Int($<full-date>.made<month>)),
            :day(Int($<full-date>.made<day>)),
            :hour(Int($<partial-time>.made<hour>)),
            :minute(Int($<partial-time>.made<minute>)),
            :second(Rat($<partial-time>.made<second>)),
            :timezone($.date-local-offset)
        )
    );
}

method date-time($/ --> Nil)
{
    make(
        %(
            :year(Int($<full-date>.made<year>)),
            :month(Int($<full-date>.made<month>)),
            :day(Int($<full-date>.made<day>)),
            :hour(Int($<full-time>.made<hour>)),
            :minute(Int($<full-time>.made<minute>)),
            :second(Rat($<full-time>.made<second>)),
            :timezone(Int($<full-time>.made<timezone>))
        )
    );
}

method date:full-date ($/ --> Nil)
{
    my Date:D $make = Date.new(|$<full-date>.made);
    make(TOMLDate['FullDate'].new(:$make));
}

method date:date-time-omit-local-offset ($/ --> Nil)
{
    my Date:D $make = DateTime.new(|$<date-time-omit-local-offset>.made);
    make(TOMLDate['DateTime', 'OmitLocalOffset'].new(:$make));
}

method date:date-time ($/ --> Nil)
{
    my DateTime:D $make = DateTime.new(|$<date-time>.made);
    make(TOMLDate['DateTime'].new(:$make));
}

method time($/ --> Nil)
{
    my %make = $<partial-time>.made;
    make(TOMLTime.new(:%make));
}

# end datetime grammar-actions }}}
# array grammar-actions {{{

method array-elements:strings ($/ --> Nil)
{
    my TOMLString:D @make = @<string>.hyper.map({ .made });
    make(TOMLArrayElements['Strings'].new(:@make));
}

method array-elements:integers ($/ --> Nil)
{
    my TOMLInteger:D @make = @<integer>.hyper.map({ .made });
    make(TOMLArrayElements['Integers'].new(:@make));
}

method array-elements:floats ($/ --> Nil)
{
    my TOMLFloat:D @make = @<float>.hyper.map({ .made });
    make(TOMLArrayElements['Floats'].new(:@make));
}

method array-elements:booleans ($/ --> Nil)
{
    my TOMLBoolean:D @make = @<boolean>.hyper.map({ .made });
    make(TOMLArrayElements['Booleans'].new(:@make));
}

method array-elements:dates ($/ --> Nil)
{
    my TOMLDate:D @make = @<date>.hyper.map({ .made });
    make(TOMLArrayElements['Dates'].new(:@make));
}

method array-elements:times ($/ --> Nil)
{
    my TOMLDate:D @make = @<time>.hyper.map({ .made });
    make(TOMLArrayElements['Times'].new(:@make));
}

method array-elements:arrays ($/ --> Nil)
{
    my TOMLArray:D @make = @<array>.hyper.map({ .made });
    make(TOMLArrayElements['Arrays'].new(:@make));
}

method array-elements:table-inlines ($/ --> Nil)
{
    my TOMLTableInline:D @make = @<table-inline>.hyper.map({ .made });
    make(TOMLArrayElements['TableInlines'].new(:@make));
}

multi method array($/ where $<array-elements>.so --> Nil)
{
    my TOMLArrayElements:D $make = $<array-elements>.made;
    make(TOMLArray.new(:$make));
}

multi method array($/ --> Nil)
{
    my TOMLArrayElements['Empty'] $make .= new(:make([]));
    make(TOMLArray.new(:$make));
}

# end array grammar-actions }}}
# table grammar-actions {{{

method keypair-key-dotted($/ --> Nil)
{
    my TOMLKeypairKeySingle:D @make =
        @<keypair-key-single>.hyper.map({ .made });
    make(TOMLKeypairKeyDotted.new(:@make));
}

method keypair-key-single-bare($/ --> Nil)
{
    my Str:D $make = ~$/;
    make(TOMLKeypairKeySingleBare.new(:$make));
}

method keypair-key-single:bare ($/ --> Nil)
{
    my TOMLKeypairKeySingleBare:D $make = $<keypair-key-single-bare>.made;
    make(TOMLKeypairKeySingle['Bare'].new(:$make));
}

method keypair-key-single-string:basic ($/ --> Nil)
{
    my TOMLString['Basic'] $make .= new(:make($<string-basic>.made));
    make(TOMLKeypairKeySingleString['Basic'].new(:$make));
}

method keypair-key-single-string:literal ($/ --> Nil)
{
    my TOMLString['Literal'] $make .= new(:make($<string-literal>.made));
    make(TOMLKeypairKeySingleString['Literal'].new(:$make));
}

method keypair-key-single:quoted ($/ --> Nil)
{
    my TOMLKeypairKeySingleString:D $make = $<keypair-key-single-string>.made;
    make(TOMLKeypairKeySingle['Quoted'].new(:$make));
}

method keypair-key:dotted ($/ --> Nil)
{
    my TOMLKeypairKeyDotted:D $make = $<keypair-key-dotted>.made;
    make(TOMLKeypairKey['Dotted'].new(:$make));
}

method keypair-key:single ($/ --> Nil)
{
    my TOMLKeypairKeySingle:D $make = $<keypair-key-single>.made;
    make(TOMLKeypairKey['Single'].new(:$make));
}

method keypair-value:string ($/ --> Nil)
{
    my TOMLString:D $make = $<string>.made;
    make(TOMLKeypairValue['String'].new(:$make));
}

method keypair-value:number ($/ --> Nil)
{
    my TOMLNumber:D $make = $<number>.made;
    make(TOMLKeypairValue['Number'].new(:$make));
}

method keypair-value:boolean ($/ --> Nil)
{
    my TOMLBoolean:D $make = $<boolean>.made;
    make(TOMLKeypairValue['Boolean'].new(:$make));
}

method keypair-value:date ($/ --> Nil)
{
    my TOMLDate:D $make = $<date>.made;
    make(TOMLKeypairValue['Date'].new(:$make));
}

method keypair-value:time ($/ --> Nil)
{
    my TOMLTime:D $make = $<time>.made;
    make(TOMLKeypairValue['Time'].new(:$make));
}

method keypair-value:array ($/ --> Nil)
{
    my TOMLArray:D $make = $<array>.made;
    make(TOMLKeypairValue['Array'].new(:$make));
}

method keypair-value:table-inline ($/ --> Nil)
{
    my TOMLTableInline:D $make = $<table-inline>.made;
    make(TOMLKeypairValue['TableInline'].new(:$make));
}

method keypair($/ --> Nil)
{
    my TOMLKeypairKey:D $key = $<keypair-key>.made;
    my TOMLKeypairValue:D $value = $<keypair-value>.made;
    my TOMLKeypairValue:D %make{TOMLKeypairKey:D} = $key => $value;
    make(TOMLKeypair.new(:%make));
}

method table-inline-keypairs($/ --> Nil)
{
    my TOMLKeypair:D @make = @<keypair>.hyper.map({ .made });
    make(TOMLTableInlineKeypairs['Populated'].new(:@make));
}

# inline table contains keypairs
multi method table-inline($/ where $<table-inline-keypairs>.so --> Nil)
{
    my TOMLTableInlineKeypairs['Populated'] $make =
        $<table-inline-keypairs>.made;

    # check for duplicate keys
    my Exception:U $exception-type =
        X::Config::TOML::InlineTable::DuplicateKeys;
    my Str:D $subject = 'inline table';
    my Str:D $text = ~$/;
    verify-no-duplicate-keys($make, $exception-type, $subject, $text);

    make(TOMLTableInline.new(:$make));
}

# inline table is empty
multi method table-inline($/ --> Nil)
{
    my TOMLTableInlineKeypairs['Empty'] $make .= new(:make([]));
    make(TOMLTableInline.new(:$make));
}

# end table grammar-actions }}}
# document grammar-actions {{{

method keypair-line($/ --> Nil)
{
    my TOMLKeypair:D $make = $<keypair>.made;
    make(TOMLKeypairLine.new(:$make));
}

method table-header-text($/ --> Nil)
{
    my TOMLKeypairKeySingle:D @make =
        @<keypair-key-single>.hyper.map({ .made });
    make(TOMLTableHeaderText.new(:@make));
}

method hoh-header($/ --> Nil)
{
    my TOMLTableHeaderText:D $make = $<table-header-text>.made;
    make(TOMLHOHHeader.new(:$make));
}

multi method table:hoh ($/ where @<keypair-line>.so --> Nil)
{
    my TOMLHOHHeader:D $key = $<hoh-header>.made;
    my TOMLKeypairLine:D @make = @<keypair-line>.hyper.map({ .made });
    my TOMLKeypairLines['Populated'] $value .= new(:@make);

    # check for duplicate keys
    my Exception:U $exception-type = X::Config::TOML::HOH::DuplicateKeys;
    my Str:D $subject = 'table';
    my Str:D $text = ~$/;
    verify-no-duplicate-keys($value, $exception-type, $subject, $text);

    my TOMLKeypairLines:D %make{TOMLHOHHeader:D} = $key => $value;
    make(TOMLTable['HOH'].new(:%make));
}

multi method table:hoh ($/ --> Nil)
{
    my TOMLHOHHeader:D $key = $<hoh-header>.made;
    my TOMLKeypairLines['Empty'] $value .= new(:make([]));
    my TOMLKeypairLines:D %make{TOMLHOHHeader:D} = $key => $value;
    make(TOMLTable['HOH'].new(:%make));
}

method aoh-header($/ --> Nil)
{
    my TOMLTableHeaderText:D $make = $<table-header-text>.made;
    make(TOMLAOHHeader.new(:$make));
}

multi method table:aoh ($/ where @<keypair-line>.so --> Nil)
{
    my TOMLAOHHeader:D $key = $<aoh-header>.made;
    my TOMLKeypairLine:D @make = @<keypair-line>.hyper.map({ .made });
    my TOMLKeypairLines['Populated'] $value .= new(:@make);

    # check for duplicate keys
    my Exception:U $exception-type = X::Config::TOML::AOH::DuplicateKeys;
    my Str:D $subject = 'array table';
    my Str:D $text = ~$/;
    verify-no-duplicate-keys($value, $exception-type, $subject, $text);

    my TOMLKeypairLines:D %make{TOMLAOHHeader:D} = $key => $value;
    make(TOMLTable['AOH'].new(:%make));
}

multi method table:aoh ($/ --> Nil)
{
    my TOMLAOHHeader:D $key = $<aoh-header>.made;
    my TOMLKeypairLines['Empty'] $value .= new(:make([]));
    my TOMLKeypairLines:D %make{TOMLAOHHeader:D} = $key => $value;
    make(TOMLTable['AOH'].new(:%make));
}

# this segment represents keypair lines not belonging to any table
method segment:keypair-line ($/ --> Nil)
{
    my TOMLKeypairLine:D $make = $<keypair-line>.made;
    make(TOMLSegment['KeypairLine'].new(:$make));
}

method segment:table ($/ --> Nil)
{
    my TOMLTable:D $make = $<table>.made;
    make(TOMLSegment['Table'].new(:$make));
}

multi method document($/ where @<segment>.so --> Nil)
{
    my TOMLSegment:D @make = @<segment>.hyper.map({ .made }).grep({ .so });

    # check for duplicate KeypairLine keys
    my TOMLSegment['KeypairLine'] @k =
        @make.hyper.grep(TOMLSegment['KeypairLine']);
    my Str:D $subject = 'independent keypair line section';
    my Str:D $text = to-string(@k);
    my Exception:U $exception-type =
        X::Config::TOML::KeypairLine::DuplicateKeys;
    verify-no-duplicate-keys(@k, $exception-type, $subject, $text);

    # findall Segment['Table']
    # - grep Table['AOH'], take unique paths, because repeat is ok
    # combine all of the above
    make(TOMLDocument['Populated'].new(:@make));
}

multi method document($/ --> Nil)
{
    make(TOMLDocument['Empty'].new(:make([])));
}

method TOP($/ --> Nil)
{
    my TOMLDocument:D $make = $<document>.made;
    make(TOML.new(:$make));
}

# end document grammar-actions }}}

# helper {{{

# --- sub is-path-clear {{{

multi sub is-path-clear(
    Array[Str:D] @k
    --> Bool:D
)
{
    my %k;
    my Bool:D $is-path-clear = is-path-clear(%k, @k);
}

multi sub is-path-clear(
    %k,
    Array[Str:D] @k
    --> Bool:D
)
{
    my Bool:D @set-true = @k.map(-> Str:D @l { set-true(%k, @l) });
    my Bool:D $is-path-clear = [&&] @set-true;
}

multi sub set-true(
    %k,
    Str:D @path where { Crane.exists(%k, :@path) }
    --> Bool:D
)
{
    my Bool:D $set-true = False;
}

multi sub set-true(
    %k,
    Str:D @path
    --> Bool:D
)
{
    try Crane.set(%k, :@path, :value(True));
    my Bool:D $set-true = Crane.exists(%k, :@path);
}

# --- end sub is-path-clear }}}
# --- sub is-without-duplicate-keys {{{

multi sub is-without-duplicate-keys(TOMLKeypairKey:D @key --> Bool:D)
{
    my TOMLKeypairKey['Dotted'] @dotted = @key.grep(TOMLKeypairKey['Dotted']);
    my TOMLKeypairKey['Single'] @single = @key.grep(TOMLKeypairKey['Single']);
    my Array[TOMLKeypairKey:D] %key{TOMLKeypairKey:U} =
        TOMLKeypairKey['Dotted'] => Array[TOMLKeypairKey:D].new(@dotted),
        TOMLKeypairKey['Single'] => Array[TOMLKeypairKey:D].new(@single);
    my Bool:D $is-without-duplicate-keys = is-without-duplicate-keys(%key);
}

multi sub is-without-duplicate-keys(%key --> Bool:D)
{
    my Array[Str:D] @dotted =
        %key{TOMLKeypairKey['Dotted']}.hyper.map({ Array[Str:D].new(.made) });
    # transform single.made into Array[Str:D] from Str:D for comparison
    my Array[Str:D] @single =
        %key{TOMLKeypairKey['Single']}.hyper.map({ Array[Str:D].new(.made) });
    my Array[Str:D] @combined = |@dotted, |@single;
    my Bool:D $is-without-duplicate-keys = is-path-clear(@combined);
}

# --- end sub is-without-duplicate-keys }}}
# --- sub to-string {{{

multi sub to-string(TOMLSegment['KeypairLine'] @k --> Str:D)
{
    my Str:D @s = @k.hyper.map({ .Str });
    my Str:D $s = @s.join("\n");
}

# --- end sub to-string }}}
# --- sub verify-no-duplicate-keys {{{

# inline table handling
multi sub verify-no-duplicate-keys(
    TOMLTableInlineKeypairs['Populated'] $k,
    Exception:U $exception-type,
    Str:D $subject,
    Str:D $text
    --> Nil
)
{
    my @keypair = Array[Hash[TOMLKeypairValue:D,TOMLKeypairKey:D]].new($k.made);
    verify-no-duplicate-keys(@keypair, $exception-type, $subject, $text);
}

# table and arraytable handling
multi sub verify-no-duplicate-keys(
    TOMLKeypairLines['Populated'] $k,
    Exception:U $exception-type,
    Str:D $subject,
    Str:D $text
    --> Nil
)
{
    my @keypair = Array[Hash[TOMLKeypairValue:D,TOMLKeypairKey:D]].new($k.made);
    verify-no-duplicate-keys(@keypair, $exception-type, $subject, $text);
}

# independent keypairline handling
multi sub verify-no-duplicate-keys(
    TOMLSegment['KeypairLine'] @k,
    Exception:U $exception-type,
    Str:D $subject,
    Str:D $text
    --> Nil
)
{
    my @keypair =
        Array[Hash[TOMLKeypairValue:D,TOMLKeypairKey:D]].new(
            @k.hyper.map({ .make.made })
        );
    verify-no-duplicate-keys(@keypair, $exception-type, $subject, $text);
}

multi sub verify-no-duplicate-keys(
    @keypair,
    Exception:U $exception-type,
    Str:D $subject,
    Str:D $text
    --> Nil
)
{
    my TOMLKeypairKey:D @key = @keypair.hyper.map({ .keys.first });
    my Bool:D $is-without-duplicate-keys = is-without-duplicate-keys(@key);
    $is-without-duplicate-keys
        or die($exception-type.new(:$subject, :$text));
}

# --- end sub verify-no-duplicate-keys }}}

# end helper }}}

# vim: set filetype=perl6 foldmethod=marker foldlevel=0:
