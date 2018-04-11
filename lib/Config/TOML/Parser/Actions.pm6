use v6;
use Config::TOML::Parser::ParseTree;
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
    my Str:D $made = $<string-basic>.made;
    make(TOMLString['Basic'].new(:$made));
}

method string:basic-multi ($/ --> Nil)
{
    my Str:D $made = $<string-basic-multiline>.made;
    make(TOMLString['Basic', 'Multiline'].new(:$made));
}

method string:literal ($/ --> Nil)
{
    my Str:D $made = $<string-literal>.made;
    make(TOMLString['Literal'].new(:$made));
}

method string:literal-multi ($/ --> Nil)
{
    my Str:D $made = $<string-literal-multiline>.made;
    make(TOMLString['Literal', 'Multiline'].new(:$made));
}

# end string grammar-actions }}}
# number grammar-actions {{{

method float($/ --> Nil)
{
    my $made = +$/;
    make(TOMLFloat['Common'].new(:$made));
}

multi method float-inf($/ where $<plus-or-minus>.so --> Nil)
{
    my Int:D $multiplier = $<plus-or-minus>.made eq '+' ?? 1 !! -1;
    my $made = Inf * $multiplier;
    make(TOMLFloat['Inf'].new(:$made));
}

multi method float-inf($/ --> Nil)
{
    my $made = Inf;
    make(TOMLFloat['Inf'].new(:$made));
}

method float-nan($/ --> Nil)
{
    my $made = NaN;
    make(TOMLFloat['NaN'].new(:$made));
}

method integer($/ --> Nil)
{
    my Int:D $made = Int(+$/);
    make(TOMLInteger['Common'].new(:$made));
}

method integer-bin($/ --> Nil)
{
    my Int:D $made = Int(+$/);
    make(TOMLInteger['Binary'].new(:$made));
}

method integer-hex($/ --> Nil)
{
    my Int:D $made = Int(+$/);
    make(TOMLInteger['Hexadecimal'].new(:$made));
}

method integer-oct($/ --> Nil)
{
    my Int:D $made = Int(+$/);
    make(TOMLInteger['Octal'].new(:$made));
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
    my TOMLFloat['Common'] $made = $<float>.made;
    make(TOMLNumber['Float'].new(:$made));
}

method number:float-inf ($/ --> Nil)
{
    my TOMLFloat['Inf'] $made = $<float-inf>.made;
    make(TOMLNumber['Float'].new(:$made));
}

method number:float-nan ($/ --> Nil)
{
    my TOMLFloat['NaN'] $made = $<float-nan>.made;
    make(TOMLNumber['Float'].new(:$made));
}

method number:integer ($/ --> Nil)
{
    my TOMLInteger['Common'] $made = $<integer>.made;
    make(TOMLNumber['Integer'].new(:$made));
}

method number:integer-bin ($/ --> Nil)
{
    my TOMLInteger['Binary'] $made = $<integer-bin>.made;
    make(TOMLNumber['Integer'].new(:$made));
}

method number:integer-hex ($/ --> Nil)
{
    my TOMLInteger['Hexadecimal'] $made = $<integer-hex>.made;
    make(TOMLNumber['Integer'].new(:$made));
}

method number:integer-oct ($/ --> Nil)
{
    my TOMLInteger['Octal'] $made = $<integer-oct>.made;
    make(TOMLNumber['Integer'].new(:$made));
}

# end number grammar-actions }}}
# boolean grammar-actions {{{

method boolean:sym<true>($/ --> Nil)
{
    my Bool:D $made = True;
    make(TOMLBoolean['True'].new(:$made));
}

method boolean:sym<false>($/ --> Nil)
{
    my Bool:D $made = False;
    make(TOMLBoolean['False'].new(:$made));
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
    my Date:D $made = Date.new(|$<full-date>.made);
    make(TOMLDate['FullDate'].new(:$made));
}

method date:date-time-omit-local-offset ($/ --> Nil)
{
    my Date:D $made = DateTime.new(|$<date-time-omit-local-offset>.made);
    make(TOMLDate['DateTime', 'OmitLocalOffset'].new(:$made));
}

method date:date-time ($/ --> Nil)
{
    my DateTime:D $made = DateTime.new(|$<date-time>.made);
    make(TOMLDate['DateTime'].new(:$made));
}

method date:partial-time ($/ --> Nil)
{
    my Hash:D $made = $<partial-time>.made;
    make(TOMLDate['PartialTime'].new(:$made));
}

# end datetime grammar-actions }}}
# array grammar-actions {{{

method array-elements:strings ($/ --> Nil)
{
    my TOMLString:D @made =
        Array[TOMLString:D].new(@<string>.hyper.map({ .made }));
    make(TOMLArrayElements['Strings'].new(:@made));
}

method array-elements:integers ($/ --> Nil)
{
    my TOMLInteger:D @made =
        Array[TOMLInteger:D].new(@<integer>.hyper.map({ .made }));
    make(TOMLArrayElements['Integers'].new(:@made));
}

method array-elements:floats ($/ --> Nil)
{
    my TOMLFloat:D @made =
        Array[TOMLFloat:D].new(@<float>.hyper.map({ .made }));
    make(TOMLArrayElements['Floats'].new(:@made));
}

method array-elements:booleans ($/ --> Nil)
{
    my TOMLBoolean:D @made =
        Array[TOMLBoolean:D].new(@<boolean>.hyper.map({ .made }));
    make(TOMLArrayElements['Booleans'].new(:@made));
}

method array-elements:dates ($/ --> Nil)
{
    my TOMLDate:D @made =
        Array[TOMLDate:D].new(@<date>.hyper.map({ .made }));
    make(TOMLArrayElements['Dates'].new(:@made));
}

method array-elements:arrays ($/ --> Nil)
{
    my TOMLArray:D @made =
        Array[TOMLArray:D].new(@<array>.hyper.map({ .made }));
    make(TOMLArrayElements['Arrays'].new(:@made));
}

method array-elements:table-inlines ($/ --> Nil)
{
    my TOMLTableInline:D @made =
        Array[TOMLTableInline:D].new(@<table-inline>.hyper.map({ .made }));
    make(TOMLArrayElements['TableInlines'].new(:@made));
}

multi method array($/ where $<array-elements>.so --> Nil)
{
    my TOMLArrayElements:D $made = $<array-elements>.made;
    make(TOMLArray.new(:$made));
}

multi method array($/ --> Nil)
{
    my TOMLArrayElements['Empty'] $made .= new(:made([]));
    make(TOMLArray.new(:$made));
}

# end array grammar-actions }}}
# table grammar-actions {{{

method keypair-key-dotted($/ --> Nil)
{
    my TOMLKeypairKeySingle:D @made =
        Array[TOMLKeypairKeySingle:D].new(
            @<keypair-key-single>.hyper.map({ .made })
        );
    make(TOMLKeypairKeyDotted.new(:@made));
}

method keypair-key-single-bare($/ --> Nil)
{
    my Str:D $made = ~$/;
    make(TOMLKeypairKeySingleBare.new(:$made));
}

method keypair-key-single:bare ($/ --> Nil)
{
    my TOMLKeypairKeySingleBare:D $made = $<keypair-key-single-bare>.made;
    make(TOMLKeypairKeySingle['Bare'].new(:$made));
}

method keypair-key-single-string:basic ($/ --> Nil)
{
    my TOMLString['Basic'] $made .= new(:made($<string-basic>.made));
    make(TOMLKeypairKeySingleString['Basic'].new(:$made));
}

method keypair-key-single-string:literal ($/ --> Nil)
{
    my TOMLString['Literal'] $made .= new(:made($<string-literal>.made));
    make(TOMLKeypairKeySingleString['Literal'].new(:$made));
}

method keypair-key-single:quoted ($/ --> Nil)
{
    my TOMLKeypairKeySingleString:D $made = $<keypair-key-single-string>.made;
    make(TOMLKeypairKeySingle['Quoted'].new(:$made));
}

method keypair-key:dotted ($/ --> Nil)
{
    my TOMLKeypairKeyDotted:D $made = $<keypair-key-dotted>.made;
    make(TOMLKeypairKey['Dotted'].new(:$made));
}

method keypair-key:single ($/ --> Nil)
{
    my TOMLKeypairKeySingle:D $made = $<keypair-key-single>.made;
    make(TOMLKeypairKey['Single'].new(:$made));
}

method keypair-value:string ($/ --> Nil)
{
    my TOMLString:D $made = $<string>.made;
    make(TOMLKeypairValue['String'].new(:$made));
}

method keypair-value:number ($/ --> Nil)
{
    my TOMLNumber:D $made = $<number>.made;
    make(TOMLKeypairValue['Number'].new(:$made));
}

method keypair-value:boolean ($/ --> Nil)
{
    my TOMLBoolean:D $made = $<boolean>.made;
    make(TOMLKeypairValue['Boolean'].new(:$made));
}

method keypair-value:date ($/ --> Nil)
{
    my TOMLDate:D $made = $<date>.made;
    make(TOMLKeypairValue['Date'].new(:$made));
}

method keypair-value:array ($/ --> Nil)
{
    my TOMLArray:D $made = $<array>.made;
    make(TOMLKeypairValue['Array'].new(:$made));
}

method keypair-value:table-inline ($/ --> Nil)
{
    my TOMLTableInline:D $made = $<table-inline>.made;
    make(TOMLKeypairValue['TableInline'].new(:$made));
}

method keypair($/ --> Nil)
{
    my TOMLKeypairKey:D $key = $<keypair-key>.made;
    my TOMLKeypairValue:D $value = $<keypair-value>.made;
    my TOMLKeypairValue:D %made{TOMLKeypairKey:D} = $key => $value;
    make(TOMLKeypair.new(:%made));
}

method table-inline-keypairs($/ --> Nil)
{
    my TOMLKeypair:D @made =
        Array[TOMLKeypair:D].new(@<keypair>.hyper.map({ .made }));
    make(TOMLTableInlineKeypairs['Populated'].new(:@made));
}

# inline table contains keypairs
multi method table-inline($/ where $<table-inline-keypairs>.so --> Nil)
{
    my TOMLTableInlineKeypairs['Populated'] $made =
        $<table-inline-keypairs>.made;
    make(TOMLTableInline.new(:$made));
}

# inline table is empty
multi method table-inline($/ --> Nil)
{
    my TOMLTableInlineKeypairs['Empty'] $made .= new(:made([]));
    make(TOMLTableInline.new(:$made));
}

# end table grammar-actions }}}
# document grammar-actions {{{

method keypair-line($/ --> Nil)
{
    my TOMLKeypair:D $made = $<keypair>.made;
    make(TOMLKeypairLine.new(:$made));
}

method table-header-text($/ --> Nil)
{
    my TOMLKeypairKeySingle:D @made =
        Array[TOMLKeypairKeySingle:D].new(
            @<keypair-key-single>.hyper.map({ .made })
        );
    make(TOMLTableHeaderText.new(:@made));
}

method hoh-header($/ --> Nil)
{
    my TOMLTableHeaderText:D $made = $<table-header-text>.made;
    make(TOMLHOHHeader.new(:$made));
}

multi method table:hoh ($/ where @<keypair-line>.so --> Nil)
{
    my TOMLHOHHeader:D $key = $<hoh-header>.made;
    my TOMLKeypairLine:D @made = @<keypair-line>.hyper.map({ .made });
    my TOMLKeypairLines['Populated'] $value .= new(:@made);
    my TOMLKeypairLines:D %made{TOMLHOHHeader:D} = $key => $value;
    make(TOMLTable['HOH'].new(:%made));
}

multi method table:hoh ($/ --> Nil)
{
    my TOMLHOHHeader:D $key = $<hoh-header>.made;
    my TOMLKeypairLines['Empty'] $value .= new(:made([]));
    my TOMLKeypairLines:D %made{TOMLHOHHeader:D} = $key => $value;
    make(TOMLTable['HOH'].new(:%made));
}

method aoh-header($/ --> Nil)
{
    my TOMLTableHeaderText:D $made = $<table-header-text>.made;
    make(TOMLAOHHeader.new(:$made));
}

multi method table:aoh ($/ where @<keypair-line>.so --> Nil)
{
    my TOMLAOHHeader:D $key = $<aoh-header>.made;
    my TOMLKeypairLine:D @made = @<keypair-line>.hyper.map({ .made });
    my TOMLKeypairLines['Populated'] $value .= new(:@made);
    my TOMLKeypairLines:D %made{TOMLAOHHeader:D} = $key => $value;
    make(TOMLTable['AOH'].new(:%made));
}

multi method table:aoh ($/ --> Nil)
{
    my TOMLAOHHeader:D $key = $<aoh-header>.made;
    my TOMLKeypairLines['Empty'] $value .= new(:made([]));
    my TOMLKeypairLines:D %made{TOMLAOHHeader:D} = $key => $value;
    make(TOMLTable['AOH'].new(:%made));
}

# this segment represents keypair lines not belonging to any table
method segment:keypair-line ($/ --> Nil)
{
    my TOMLKeypairLine:D $made = $<keypair-line>.made;
    make(TOMLSegment['KeypairLine'].new(:$made));
}

method segment:table ($/ --> Nil)
{
    my TOMLTable:D $made = $<table>.made;
    make(TOMLSegment['Table'].new(:$made));
}

multi method document($/ where @<segment>.so --> Nil)
{
    my TOMLSegment:D @made =
        Array[TOMLSegment:D].new(@<segment>.hyper.map({ .made }).grep(*.so));
    make(TOMLDocument['Populated'].new(:@made));
}

multi method document($/ --> Nil)
{
    make(TOMLDocument['Empty'].new(:made([])));
}

method TOP($/ --> Nil)
{
    my TOMLDocument:D $made = $<document>.made;
    make(TOML.new(:$made));
}

# end document grammar-actions }}}

# vim: set filetype=perl6 foldmethod=marker foldlevel=0:
