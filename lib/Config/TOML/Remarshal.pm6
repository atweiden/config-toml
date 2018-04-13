use v6;
use Config::TOML::Parser::ParseTree;
unit class Config::TOML::Remarshal;

# string {{{

multi sub remarshal(TOMLString['Basic'] $s --> Str:D)
{
    my Str:D $r = $s.make;
}

multi sub remarshal(TOMLString['Basic', 'Multiline'] $s --> Str:D)
{
    my Str:D $r = $s.make;
}

multi sub remarshal(TOMLString['Literal'] $s --> Str:D)
{
    my Str:D $r = $s.make;
}

multi sub remarshal(TOMLString['Literal', 'Multiline'] $s --> Str:D)
{
    my Str:D $r = $s.make;
}

# end string }}}
# number {{{

multi sub remarshal(TOMLFloat['Common'] $f --> Numeric:D)
{
    my Numeric:D $r = $f.make;
}

multi sub remarshal(TOMLFloat['Inf'] $f --> Numeric:D)
{
    my Numeric:D $r = $f.make;
}

multi sub remarshal(TOMLFloat['NaN'] $f --> Numeric:D)
{
    my Numeric:D $r = $f.make;
}

multi sub remarshal(TOMLInteger['Common'] $i --> Int:D)
{
    my Int:D $r = $i.make;
}

multi sub remarshal(TOMLInteger['Binary'] $i --> Int:D)
{
    my Int:D $r = $i.make;
}

multi sub remarshal(TOMLInteger['Hexadecimal'] $i --> Int:D)
{
    my Int:D $r = $i.make;
}

multi sub remarshal(TOMLInteger['Octal'] $i --> Int:D)
{
    my Int:D $r = $i.make;
}

multi sub remarshal(TOMLNumber['Float'] $n --> Numeric:D)
{
    my TOMLFloat:D $f = $n.make;
    my Numeric:D $r = remarshal($f);
}

multi sub remarshal(TOMLNumber['Integer'] $n --> Int:D)
{
    my TOMLInteger:D $i = $n.make;
    my Int:D $r = remarshal($i);
}

# end number }}}
# boolean {{{

multi sub remarshal(TOMLBoolean['True'] $b --> Bool:D)
{
    my Bool:D $r = $b.make;
}

multi sub remarshal(TOMLBoolean['False'] $b --> Bool:D)
{
    my Bool:D $r = $b.make;
}

# end boolean }}}
# datetime {{{

multi sub remarshal(TOMLDate['DateTime'] $d --> DateTime:D)
{
    my DateTime:D $r = $d.make;
}

multi sub remarshal(TOMLDate['DateTime', 'OmitLocalOffset'] $d --> DateTime:D)
{
    my DateTime:D $r = $d.make;
}

multi sub remarshal(TOMLDate['FullDate'] $d --> Date:D)
{
    my Date:D $r = $d.make;
}

multi sub remarshal(TOMLTime $t --> Hash:D)
{
    my %r = $t.make;
}

# end datetime }}}
# array {{{

multi sub remarshal(TOMLArrayElements['Strings'] $a --> Array:D)
{
    my @r =
        $a.make.map(-> TOMLString:D $s {
            my Str:D $r = remarshal($s);
        });
}

multi sub remarshal(TOMLArrayElements['Integers'] $a --> Array:D)
{
    my @r =
        $a.make.map(-> TOMLInteger:D $i {
            my Int:D $r = remarshal($i);
        });
}

multi sub remarshal(TOMLArrayElements['Floats'] $a --> Array:D)
{
    my @r =
        $a.make.map(-> TOMLFloat:D $f {
            my Numeric:D $r = remarshal($f);
        });
}

multi sub remarshal(TOMLArrayElements['Booleans'] $a --> Array:D)
{
    my @r =
        $a.make.map(-> TOMLBoolean:D $b {
            my Bool:D $r = remarshal($b);
        });
}

multi sub remarshal(TOMLArrayElements['Dates'] $a --> Array:D)
{
    my @r =
        $a.make.map(-> TOMLDate:D $d {
            my Dateish:D $r = remarshal($d);
        });
}

multi sub remarshal(TOMLArrayElements['Times'] $a --> Array:D)
{
    my @r =
        $a.make.map(-> TOMLTime:D $t {
            my %r = remarshal($t)
        });
}

multi sub remarshal(TOMLArrayElements['Arrays'] $a --> Array:D)
{
    my @r =
        $a.make.map(-> TOMLArray:D $y {
            my @a = remarshal($y);
        });
}

multi sub remarshal(TOMLArrayElements['TableInlines'] $a --> Array:D)
{
    my @r =
        $a.make.map(-> TOMLTableInline:D $t {
            my %r = remarshal($t)
        });
}

multi sub remarshal(TOMLArrayElements['Empty'] $ --> Array:D)
{
    my @r;
}

multi sub remarshal(TOMLArray $a --> Array:D)
{
    my @r =
        $a.make.map(-> TOMLArrayElements:D $e {
            my @e = remarshal($e);
        });
}

# end array }}}
# table {{{

multi sub remarshal(TOMLKeypairKeySingleBare $k --> Str:D)
{
    my Str:D $r = $k.make;
}

multi sub remarshal(TOMLKeypairKeySingle['Bare'] $k --> Str:D)
{
    my TOMLKeypairKeySingleBare $l = $k.make;
    my Str:D $r = remarshal($l);
}

multi sub remarshal(TOMLKeypairKeySingleString['Basic'] $s --> Str:D)
{
    my TOMLString['Basic'] $t = $s.make;
    my Str:D $r = remarshal($t);
}

multi sub remarshal(TOMLKeypairKeySingleString['Literal'] $s --> Str:D)
{
    my TOMLString['Literal'] $t = $s.make;
    my Str:D $r = remarshal($t);
}

multi sub remarshal(TOMLKeypairKeySingle['Quoted'] $k --> Str:D)
{
    my TOMLKeypairKeySingleString:D $s = $k.make;
    my Str:D $r = remarshal($s);
}

multi sub remarshal(TOMLKeypairKey['Single'] $k --> Str:D)
{
    my TOMLKeypairKeySingle:D $l = $k.make;
    my Str:D $r = remarshal($l);
}

multi sub remarshal(TOMLKeypairKeyDotted $k --> Array[Str:D])
{
    my TOMLKeypairKeySingle:D @k = $k.make;
    my Str:D @r =
        Array[Str:D].new(
            @k.map(-> TOMLKeypairKeySingle $l {
                my Str:D $r = remarshal($l);
            })
        );
}

multi sub remarshal(TOMLKeypairKey['Dotted'] $k --> Array[Str:D])
{
    my TOMLKeypairKeyDotted:D $l = $k.make;
    my Str:D @r = remarshal($l);
}

multi sub remarshal(TOMLKeypairValue['String'] $s --> Str:D)
{
    my TOMLString:D $t = $s.make;
    my Str:D $r = remarshal($t);
}

multi sub remarshal(TOMLKeypairValue['Number'] $n --> Numeric:D)
{
    my TOMLNumber:D $o = $n.make;
    my Numeric:D $r = remarshal($o);
}

multi sub remarshal(TOMLKeypairValue['Boolean'] $b --> Bool:D)
{
    my TOMLBoolean:D $c = $b.make;
    my Bool:D $r = remarshal($c);
}

multi sub remarshal(TOMLKeypairValue['Date'] $d --> Dateish:D)
{
    my TOMLDate:D $e = $d.make;
    my Dateish:D $r = remarshal($e);
}

multi sub remarshal(TOMLKeypairValue['Array'] $a --> Array:D)
{
    my TOMLArray:D $b = $a.make;
    my @r = remarshal($b);
}

multi sub remarshal(TOMLKeypairValue['TableInline'] $t --> Hash:D)
{
    my TOMLTableInline:D $u = $t.make;
    my %r = remarshal($u);
}

multi sub remarshal(
    TOMLKeypair:D $p
    --> Hash[TOMLKeypairValue:D,TOMLKeypairKey:D]
)
{
    my TOMLKeypairKey:D $k = $p.make.keys.first;
    my TOMLKeypairValue:D $v = $p.make.values.first;
    my TOMLKeypairValue:D %r{TOMLKeypairKey:D} =
        Hash[TOMLKeypairValue:D,TOMLKeypairKey:D].new($k => $v);
}

multi sub remarshal(
    TOMLTableInlineKeypairs['Populated'] $p
    --> Array[Hash[TOMLKeypairValue:D,TOMLKeypairKey:D]]
)
{
    my TOMLKeypair:D @p = $p.make;
    my Hash[TOMLKeypairValue:D,TOMLKeypairKey:D] @r =
        Array[Hash[TOMLKeypairValue:D,TOMLKeypairKey:D]].new(
            @p.map(-> TOMLKeypair $p {
                my TOMLKeypairValue:D %r{TOMLKeypairKey:D} = remarshal($p);
            })
        );
}

multi sub remarshal(
    TOMLTableInlineKeypairs['Empty'] $
    --> Array[Hash[TOMLKeypairValue:D,TOMLKeypairKey:D]]
)
{
    my Hash[TOMLKeypairValue:D,TOMLKeypairKey:D] @r;
}

multi sub remarshal(
    TOMLTableInline $t
    --> Array[Hash[TOMLKeypairValue:D,TOMLKeypairKey:D]]
)
{
    my TOMLTableInlineKeypairs:D $p = $t.make;
    my Hash[TOMLKeypairValue:D,TOMLKeypairKey:D] @r = remarshal($p);
}

# end table }}}
# document {{{

multi sub remarshal(
    TOMLKeypairLine $l
    --> Hash[TOMLKeypairValue:D,TOMLKeypairKey:D]
)
{
    my TOMLKeypair:D $p = $l.make;
    my TOMLKeypairValue:D %r{TOMLKeypairKey:D} = remarshal($p);
}

multi sub remarshal(
    TOMLKeypairLines['Populated'] $l
    --> Array[Hash[TOMLKeypairValue:D,TOMLKeypairKey:D]]
)
{
    my TOMLKeypairLine:D @l = |$l.make;
    my Hash[TOMLKeypairValue:D,TOMLKeypairKey:D] @r =
        Array[Hash[TOMLKeypairValue:D,TOMLKeypairKey:D]].new(
            @l.map(-> TOMLKeypairLine $m {
                my TOMLKeypairValue:D %r{TOMLKeypairKey:D} = remarshal($m);
            })
        );
}

multi sub remarshal(
    TOMLKeypairLines['Empty'] $
    --> Array[Hash[TOMLKeypairValue:D,TOMLKeypairKey:D]]
)
{
    my Hash[TOMLKeypairValue:D,TOMLKeypairKey:D] @r;
}

multi sub remarshal(TOMLTableHeaderText $h --> Array[Str:D])
{
    my TOMLKeypairKeySingle:D @k = |$h.make;
    my Str:D @r =
        Array[Str:D].new(
            @k.map(-> TOMLKeypairKeySingle $k {
                my Str:D $r = remarshal($k);
            })
        );
}

multi sub remarshal(TOMLHOHHeader $h --> Array[Str:D])
{
    my TOMLTableHeaderText:D $i = $h.make;
    my Str:D @r = remarshal($i);
}

multi sub remarshal(
    TOMLTable['HOH'] $t
    --> Hash[Array[Hash[TOMLKeypairValue:D,TOMLKeypairKey:D]],Array[Str:D]]
)
{
    my TOMLKeypairLines:D %t{TOMLHOHHeader:D} = $t.make;

    my TOMLHOHHeader:D $h = %t.keys.first;
    my Str:D @s = remarshal($h);

    my TOMLKeypairLines:D $l = %t.values.first;
    my Hash[TOMLKeypairValue:D,TOMLKeypairKey:D] @l = remarshal($l);

    my Array[Hash[TOMLKeypairValue:D,TOMLKeypairKey:D]] %r{Array[Str:D]} =
        @s => @l;
}

multi sub remarshal(TOMLAOHHeader $h --> Array[Str:D])
{
    my TOMLTableHeaderText:D $i = $h.make;
    my Str:D @r = remarshal($i);
}

multi sub remarshal(
    TOMLTable['AOH'] $t
    --> Hash[Array[Hash[TOMLKeypairValue:D,TOMLKeypairKey:D]],Array[Str:D]]
)
{
    my TOMLKeypairLines:D %t{TOMLAOHHeader:D} = $t.make;

    my TOMLAOHHeader:D $h = %t.keys.first;
    my Str:D @s = remarshal($h);

    my TOMLKeypairLines:D $l = %t.values.first;
    my Hash[TOMLKeypairValue:D,TOMLKeypairKey:D] @l = remarshal($l);

    my Array[Hash[TOMLKeypairValue:D,TOMLKeypairKey:D]] %r{Array[Str:D]} =
        @s => @l;
}

multi sub remarshal(
    TOMLSegment['KeypairLine'] $g
    --> Hash[Array[Hash[TOMLKeypairValue:D,TOMLKeypairKey:D]],Array[Str:D]]
)
{
    my TOMLKeypair:D $p = $g.make;
    my TOMLKeypairValue:D %p{TOMLKeypairKey:D} = remarshal($p);
    # make signature identical to TOMLSegment['Table']
    my Str:D @k;
    my Hash[TOMLKeypairValue:D,TOMLKeypairKey:D] @v =
        Array[Hash[TOMLKeypairValue:D,TOMLKeypairKey:D]].new(%p);
    my Array[Hash[TOMLKeypairValue:D,TOMLKeypairKey:D]] %r{Array[Str:D]} =
        @k => @v;
}

multi sub remarshal(
    TOMLSegment['Table'] $g
    --> Hash[Array[Hash[TOMLKeypairValue:D,TOMLKeypairKey:D]],Array[Str:D]]
)
{
    my TOMLTable:D $t = $g.make;
    my Array[Hash[TOMLKeypairValue:D,TOMLKeypairKey:D]] %r{Array[Str:D]} =
        remarshal($t);
}

multi sub remarshal(
    TOMLDocument['Populated'] $d
    --> Array[Hash[Array[Hash[TOMLKeypairValue:D,TOMLKeypairKey:D]],Array[Str:D]]]
)
{
    my TOMLSegment:D @g = |$d.make;
    my Hash[Array[Hash[TOMLKeypairValue:D,TOMLKeypairKey:D]],Array[Str:D]] @r =
        Array[Hash[Array[Hash[TOMLKeypairValue:D,TOMLKeypairKey:D]],Array[Str:D]]].new(
            @g.map(-> TOMLSegment $g {
                my Array[Hash[TOMLKeypairValue:D,TOMLKeypairKey:D]] %q{Array[Str:D]} =
                    remarshal($g);
            })
        );
}

multi sub remarshal(
    TOMLDocument['Empty'] $
    --> Array[Hash[Array[Hash[TOMLKeypairValue:D,TOMLKeypairKey:D]],Array[Str:D]]]
)
{
    my Hash[Array[Hash[TOMLKeypairValue:D,TOMLKeypairKey:D]],Array[Str:D]] @r;
}

# XXX should return plain Hash:D
multi sub remarshal(
    TOML:D $t
    --> Array[Hash[Array[Hash[TOMLKeypairValue:D,TOMLKeypairKey:D]],Array[Str:D]]]
) is export
{
    my TOMLDocument:D $d = $t.make;
    my Hash[Array[Hash[TOMLKeypairValue:D,TOMLKeypairKey:D]],Array[Str:D]] @r =
        remarshal($d);
}

# end document }}}

# vim: set filetype=perl6 foldmethod=marker foldlevel=0:
