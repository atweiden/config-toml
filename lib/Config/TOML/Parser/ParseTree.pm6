use v6;

# helper {{{

my role Made { method made() {...} }
my role Make[::T] { has T $.make is required }

# end helper }}}

# string {{{

role TOMLString['Basic']
{
    also does Made;
    also does Make[Str:D];
    method made(::?CLASS:D: --> Str:D)
    {
        my Str:D $made = $.make;
    }
}

role TOMLString['Basic', 'Multiline']
{
    also does Made;
    also does Make[Str:D];
    method made(::?CLASS:D: --> Str:D)
    {
        my Str:D $made = $.make;
    }
}

role TOMLString['Literal']
{
    also does Made;
    also does Make[Str:D];
    method made(::?CLASS:D: --> Str:D)
    {
        my Str:D $made = $.make;
    }
}

role TOMLString['Literal', 'Multiline']
{
    also does Made;
    also does Make[Str:D];
    method made(::?CLASS:D: --> Str:D)
    {
        my Str:D $made = $.make;
    }
}

# end string }}}
# number {{{

role TOMLFloat['Common']
{
    also does Made;
    also does Make[Numeric:D];
    method made(::?CLASS:D: --> Numeric:D)
    {
        my Numeric:D $made = $.make;
    }
}

role TOMLFloat['Inf']
{
    also does Made;
    also does Make[Numeric:D];
    method made(::?CLASS:D: --> Numeric:D)
    {
        my Numeric:D $made = $.make;
    }
}

role TOMLFloat['NaN']
{
    also does Made;
    also does Make[Numeric:D];
    method made(::?CLASS:D: --> Numeric:D)
    {
        my Numeric:D $made = $.make;
    }
}

role TOMLInteger['Common']
{
    also does Made;
    also does Make[Int:D];
    method made(::?CLASS:D: --> Int:D)
    {
        my Int:D $made = $.make;
    }
}

role TOMLInteger['Binary']
{
    also does Made;
    also does Make[Int:D];
    method made(::?CLASS:D: --> Int:D)
    {
        my Int:D $made = $.make;
    }
}

role TOMLInteger['Hexadecimal']
{
    also does Made;
    also does Make[Int:D];
    method made(::?CLASS:D: --> Int:D)
    {
        my Int:D $made = $.make;
    }
}

role TOMLInteger['Octal']
{
    also does Made;
    also does Make[Int:D];
    method made(::?CLASS:D: --> Int:D)
    {
        my Int:D $made = $.make;
    }
}

role TOMLNumber['Float']
{
    also does Made;
    also does Make[TOMLFloat:D];
    method made(::?CLASS:D: --> Numeric:D)
    {
        my Numeric:D $made = $.make.made;
    }
}

role TOMLNumber['Integer']
{
    also does Made;
    also does Make[TOMLInteger:D];
    method made(::?CLASS:D: --> Int:D)
    {
        my Int:D $made = $.make.made;
    }
}

# end number }}}
# boolean {{{

role TOMLBoolean['True']
{
    also does Made;
    also does Make[Bool:D];
    method made(::?CLASS:D: --> Bool:D)
    {
        my Bool:D $made = $.make;
    }
}

role TOMLBoolean['False']
{
    also does Made;
    also does Make[Bool:D];
    method made(::?CLASS:D: --> Bool:D)
    {
        my Bool:D $made = $.make;
    }
}

# end boolean }}}
# datetime {{{

role TOMLDate['DateTime']
{
    also does Made;
    also does Make[DateTime:D];
    method made(::?CLASS:D: --> DateTime:D)
    {
        my DateTime:D $made = $.make;
    }
}

role TOMLDate['DateTime', 'OmitLocalOffset']
{
    also does Made;
    also does Make[DateTime:D];
    method made(::?CLASS:D: --> DateTime:D)
    {
        my DateTime:D $made = $.make;
    }
}

role TOMLDate['FullDate']
{
    also does Made;
    also does Make[Date:D];
    method made(::?CLASS:D: --> Date:D)
    {
        my Date:D $made = $.make;
    }
}

role TOMLTime
{
    also does Made;
    also does Make[Hash:D];
    method made(::?CLASS:D: --> Hash:D)
    {
        my %made = $.make;
    }
}

# end datetime }}}
# array {{{

role TOMLArray {...}
role TOMLTableInline {...}

role TOMLArrayElements['Strings']
{
    also does Made;
    also does Make[Array[TOMLString:D]];
    method made(::?CLASS:D: --> Array[Str:D])
    {
        my Str:D @made = Array[Str:D].new($.make.hyper.map({ .made }));
    }
}

role TOMLArrayElements['Integers']
{
    also does Made;
    also does Make[Array[TOMLInteger:D]];
    method made(::?CLASS:D: --> Array[Int:D])
    {
        my Int:D @made = Array[Int:D].new($.make.hyper.map({ .made }));
    }
}

role TOMLArrayElements['Floats']
{
    also does Made;
    also does Make[Array[TOMLFloat:D]];
    method made(::?CLASS:D: --> Array[Numeric:D])
    {
        my Numeric:D @made = Array[Numeric:D].new($.make.hyper.map({ .made }));
    }
}

role TOMLArrayElements['Booleans']
{
    also does Made;
    also does Make[Array[TOMLBoolean:D]];
    method made(::?CLASS:D: --> Array[Bool:D])
    {
        my Bool:D @made = Array[Bool:D].new($.make.hyper.map({ .made }));
    }
}

role TOMLArrayElements['Dates']
{
    also does Made;
    also does Make[Array[TOMLDate:D]];
    method made(::?CLASS:D: --> Array[Dateish:D])
    {
        my Dateish:D @made = Array[Dateish:D].new($.make.hyper.map({ .made }));
    }
}

role TOMLArrayElements['Times']
{
    also does Made;
    also does Make[Array[TOMLTime:D]];
    method made(::?CLASS:D: --> Array[Hash:D])
    {
        my Hash:D @made = Array[Hash:D].new($.make.hyper.map({ .made }));
    }
}

role TOMLArrayElements['Arrays']
{
    also does Made;
    also does Make[Array[TOMLArray:D]];
    method made(::?CLASS:D: --> Array[Array:D])
    {
        my Array:D @made = Array[Array:D].new($.make.hyper.map({ .made }));
    }
}

role TOMLArrayElements['TableInlines']
{
    also does Made;
    also does Make[Array[TOMLTableInline:D]];
    method made(::?CLASS:D: --> Array[Array[Hash[Any:D,Array[Str:D]]]])
    {
        my Array[Hash[Any:D,Array[Str:D]]] @made =
            Array[Array[Hash[Any:D,Array[Str:D]]]].new(
                $.make.hyper.map({ .made })
            );
    }
}

role TOMLArrayElements['Empty']
{
    also does Made;
    also does Make[Array:D];
    method made(::?CLASS:D: --> Array:D)
    {
        my @made;
    }
}

role TOMLArray
{
    also does Made;
    also does Make[TOMLArrayElements:D];
    method made(::?CLASS:D: --> Array:D)
    {
        my @made = $.make.made;
    }
}

# end array }}}
# table {{{

role TOMLKeypairKeySingleBare
{
    also does Made;
    also does Make[Str:D];
    method made(::?CLASS:D: --> Str:D)
    {
        my Str:D $made = $.make;
    }
}

role TOMLKeypairKeySingle['Bare']
{
    also does Made;
    also does Make[TOMLKeypairKeySingleBare:D];
    method made(::?CLASS:D: --> Str:D)
    {
        my Str:D $made = $.make.made;
    }
}

role TOMLKeypairKeySingleString['Basic']
{
    also does Made;
    also does Make[TOMLString['Basic']];
    method made(::?CLASS:D: --> Str:D)
    {
        my Str:D $made = $.make.made;
    }
}

role TOMLKeypairKeySingleString['Literal']
{
    also does Made;
    also does Make[TOMLString['Literal']];
    method made(::?CLASS:D: --> Str:D)
    {
        my Str:D $made = $.make.made;
    }
}

role TOMLKeypairKeySingle['Quoted']
{
    also does Made;
    also does Make[TOMLKeypairKeySingleString:D];
    method made(::?CLASS:D: --> Str:D)
    {
        my Str:D $made = $.make.made;
    }
}

role TOMLKeypairKey['Single']
{
    also does Made;
    also does Make[TOMLKeypairKeySingle:D];
    method made(::?CLASS:D: --> Str:D)
    {
        my Str:D $made = $.make.made;
    }
}

role TOMLKeypairKeyDotted
{
    also does Made;
    also does Make[Array[TOMLKeypairKeySingle:D]];
    method made(::?CLASS:D: --> Array[Str:D])
    {
        my Str:D @made = Array[Str:D].new($.make.hyper.map({ .made }));
    }
}

role TOMLKeypairKey['Dotted']
{
    also does Made;
    also does Make[TOMLKeypairKeyDotted:D];
    method made(::?CLASS:D: --> Array[Str:D])
    {
        my Str:D @made = $.make.made;
    }
}

role TOMLKeypairValue['String']
{
    also does Made;
    also does Make[TOMLString:D];
    method made(::?CLASS:D: --> Str:D)
    {
        my Str:D $made = $.make.made;
    }
}

role TOMLKeypairValue['Number']
{
    also does Made;
    also does Make[TOMLNumber:D];
    method made(::?CLASS:D: --> Numeric:D)
    {
        my Numeric:D $made = $.make.made;
    }
}

role TOMLKeypairValue['Boolean']
{
    also does Made;
    also does Make[TOMLBoolean:D];
    method made(::?CLASS:D: --> Bool:D)
    {
        my Bool:D $made = $.make.made;
    }
}

role TOMLKeypairValue['Date']
{
    also does Made;
    also does Make[TOMLDate:D];
    method made(::?CLASS:D: --> Dateish:D)
    {
        my Dateish:D $made = $.make.made;
    }
}

role TOMLKeypairValue['Array']
{
    also does Made;
    also does Make[TOMLArray:D];
    method made(::?CLASS:D: --> Array:D)
    {
        my @made = $.make.made;
    }
}

role TOMLKeypairValue['TableInline']
{
    also does Made;
    also does Make[TOMLTableInline:D];
    method made(::?CLASS:D: --> Array[Hash[Any:D,Array[Str:D]]])
    {
        my Hash[Any:D,Array[Str:D]] @made = $.make.made;
    }
}

role TOMLKeypair
{
    also does Made;
    also does Make[Hash[TOMLKeypairValue:D,TOMLKeypairKey:D]];
    method made(::?CLASS:D: --> Hash[Any:D,Array[Str:D]])
    {
        my Str:D @key = Array[Str:D].new(|$.make.keys.first.made);
        my Any:D $value = $.make.values.first.made;
        my Any:D %made{Array[Str:D]} = @key => $value;
    }
}

role TOMLTableInlineKeypairs['Populated']
{
    also does Made;
    also does Make[Array[TOMLKeypair:D]];
    method made(::?CLASS:D: --> Array[Hash[Any:D,Array[Str:D]]])
    {
        my Hash[Any:D,Array[Str:D]] @made =
            Array[Hash[Any:D,Array[Str:D]]].new($.make.hyper.map({ .made }));
    }
}

role TOMLTableInlineKeypairs['Empty']
{
    also does Made;
    also does Make[Array:D];
    method made(::?CLASS:D: --> Array[Hash[Any:D,Array[Str:D]]])
    {
        my Hash[Any:D,Array[Str:D]] @made;
    }
}

role TOMLTableInline
{
    also does Made;
    also does Make[TOMLTableInlineKeypairs:D];
    method made(::?CLASS:D: --> Array[Hash[Any:D,Array[Str:D]]])
    {
        my Hash[Any:D,Array[Str:D]] @made = $.make.made;
    }
}

# end table }}}
# document {{{

role TOMLKeypairLine
{
    also does Made;
    also does Make[TOMLKeypair:D];
    method made(::?CLASS:D: --> Hash[Any:D,Array[Str:D]])
    {
        my Any:D %made{Array[Str:D]} = $.make.made;
    }
}

role TOMLKeypairLines['Populated']
{
    also does Made;
    also does Make[Array[TOMLKeypairLine:D]];
    method made(::?CLASS:D: --> Array[Hash[Any:D,Array[Str:D]]])
    {
        my Hash[Any:D,Array[Str:D]] @made =
            Array[Hash[Any:D,Array[Str:D]]].new($.make.hyper.map({ .made }));
    }
}

role TOMLKeypairLines['Empty']
{
    also does Made;
    also does Make[Array:D];
    method made(::?CLASS:D: --> Array[Hash[Any:D,Array[Str:D]]])
    {
        my Hash[Any:D,Array[Str:D]] @made;
    }
}

role TOMLTableHeaderText
{
    also does Made;
    also does Make[Array[TOMLKeypairKeySingle:D]];
    method made(::?CLASS:D: --> Array[Str:D])
    {
        my Str:D @made = Array[Str:D].new($.make.hyper.map({ .made }));
    }
}

role TOMLHOHHeader
{
    also does Made;
    also does Make[TOMLTableHeaderText:D];
    method made(::?CLASS:D: --> Array[Str:D])
    {
        my Str:D @made = $.make.made;
    }
}

role TOMLTable['HOH']
{
    also does Made;
    also does Make[Hash[TOMLKeypairLines:D,TOMLHOHHeader:D]];
    method made(
        ::?CLASS:D:
        --> Hash[Array[Hash[Any:D,Array[Str:D]]],Array[Str:D]]
    )
    {
        my Str:D @key = $.make.keys.first.made;
        my Hash[Any:D,Array[Str:D]] @value = $.make.values.first.made;
        my Array[Hash[Any:D,Array[Str:D]]] %made{Array[Str:D]} = @key => @value;
    }
}

role TOMLAOHHeader
{
    also does Made;
    also does Make[TOMLTableHeaderText:D];
    method made(::?CLASS:D: --> Array[Str:D])
    {
        my Str:D @made = $.make.made;
    }
}

role TOMLTable['AOH']
{
    also does Made;
    also does Make[Hash[TOMLKeypairLines:D,TOMLAOHHeader:D]];
    method made(
        ::?CLASS:D:
        --> Hash[Array[Hash[Any:D,Array[Str:D]]],Array[Str:D]]
    )
    {
        my Str:D @key = $.make.keys.first.made;
        my Hash[Any:D,Array[Str:D]] @value = $.make.values.first.made;
        my Array[Hash[Any:D,Array[Str:D]]] %made{Array[Str:D]} = @key => @value;
    }
}

role TOMLSegment['KeypairLine']
{
    also does Made;
    also does Make[TOMLKeypairLine:D];
    method made(::?CLASS:D: --> Hash[Any:D,Array[Str:D]])
    {
        my Any:D %made{Array[Str:D]} = $.make.made;
    }
}

role TOMLSegment['Table']
{
    also does Made;
    also does Make[TOMLTable:D];
    method made(
        ::?CLASS:D:
        --> Hash[Array[Hash[Any:D,Array[Str:D]]],Array[Str:D]]
    )
    {
        my Str:D @key = $.make.made.keys.first;
        my Hash[Any:D,Array[Str:D]] @value = $.make.made.values.first;
        my Array[Hash[Any:D,Array[Str:D]]] %made{Array[Str:D]} = @key => @value;
    }
}

role TOMLDocument['Populated']
{
    also does Made;
    also does Make[Array[TOMLSegment:D]];
    method made(::?CLASS:D: --> Array[Hash[Any:D,Array[Str:D]]])
    {
        my Hash[Any:D,Array[Str:D]] @made =
            Array[Hash[Any:D,Array[Str:D]]].new($.make.made);
    }
}

role TOMLDocument['Empty']
{
    also does Made;
    also does Make[Array:D];
    method made(::?CLASS:D: --> Array[Hash[Any:D,Array[Str:D]]])
    {
        my Hash[Any:D,Array[Str:D]] @made;
    }
}

role TOML
{
    also does Made;
    also does Make[TOMLDocument:D];
    method made(::?CLASS:D: --> Array[Hash[Any:D,Array[Str:D]]])
    {
        my Hash[Any:D,Array[Str:D]] @made = $.make.made;
    }
}

# end document }}}

# vim: set filetype=perl6 foldmethod=marker foldlevel=0:
