use v6;

# helper {{{

my role Made { method made() {...} }
my role Make[::T] { has T $.make is required }
my role ToStr { method Str() {...} }

# end helper }}}

# string {{{

role TOMLString['Basic']
{
    also does Made;
    also does Make[Str:D];
    also does ToStr;
    method made(::?CLASS:D: --> Str:D)
    {
        my Str:D $made = $.make;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = sprintf(Q{"%s"}, $.make.subst('"', '\"', :g));
    }
}

role TOMLString['Basic', 'Multiline']
{
    also does Made;
    also does Make[Str:D];
    also does ToStr;
    method made(::?CLASS:D: --> Str:D)
    {
        my Str:D $made = $.make;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = sprintf(Q:to/EOF/.trim, $.make);
        """
        %s
        """
        EOF
    }
}

role TOMLString['Literal']
{
    also does Made;
    also does Make[Str:D];
    also does ToStr;
    method made(::?CLASS:D: --> Str:D)
    {
        my Str:D $made = $.make;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = sprintf(Q{'%s'}, $.make);
    }
}

role TOMLString['Literal', 'Multiline']
{
    also does Made;
    also does Make[Str:D];
    also does ToStr;
    method made(::?CLASS:D: --> Str:D)
    {
        my Str:D $made = $.make;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = sprintf(Q:to/EOF/.trim, $.make);
        '''
        %s
        '''
        EOF
    }
}

# end string }}}
# number {{{

role TOMLFloat['Common']
{
    also does Made;
    also does Make[Numeric:D];
    also does ToStr;
    method made(::?CLASS:D: --> Numeric:D)
    {
        my Numeric:D $made = $.make;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = $.make.Str;
    }
}

role TOMLFloat['Inf']
{
    also does Made;
    also does Make[Numeric:D];
    also does ToStr;
    method made(::?CLASS:D: --> Numeric:D)
    {
        my Numeric:D $made = $.make;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = 'inf';
    }
}

role TOMLFloat['NaN']
{
    also does Made;
    also does Make[Numeric:D];
    also does ToStr;
    method made(::?CLASS:D: --> Numeric:D)
    {
        my Numeric:D $made = $.make;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = 'nan';
    }
}

role TOMLInteger['Common']
{
    also does Made;
    also does Make[Int:D];
    also does ToStr;
    method made(::?CLASS:D: --> Int:D)
    {
        my Int:D $made = $.make;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = $.make.Str;
    }
}

role TOMLInteger['Binary']
{
    also does Made;
    also does Make[Int:D];
    also does ToStr;
    method made(::?CLASS:D: --> Int:D)
    {
        my Int:D $made = $.make;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = sprintf(Q{0b%s}, $.make.base(2).Str);
    }
}

role TOMLInteger['Hexadecimal']
{
    also does Made;
    also does Make[Int:D];
    also does ToStr;
    method made(::?CLASS:D: --> Int:D)
    {
        my Int:D $made = $.make;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = sprintf(Q{0x%s}, $.make.base(16).Str);
    }
}

role TOMLInteger['Octal']
{
    also does Made;
    also does Make[Int:D];
    also does ToStr;
    method made(::?CLASS:D: --> Int:D)
    {
        my Int:D $made = $.make;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = sprintf(Q{0o%s}, $.make.base(8).Str);
    }
}

role TOMLNumber['Float']
{
    also does Made;
    also does Make[TOMLFloat:D];
    also does ToStr;
    method made(::?CLASS:D: --> Numeric:D)
    {
        my Numeric:D $made = $.make.made;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = $.make.Str;
    }
}

role TOMLNumber['Integer']
{
    also does Made;
    also does Make[TOMLInteger:D];
    also does ToStr;
    method made(::?CLASS:D: --> Int:D)
    {
        my Int:D $made = $.make.made;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = $.make.Str;
    }
}

# end number }}}
# boolean {{{

role TOMLBoolean['True']
{
    also does Made;
    also does Make[Bool:D];
    also does ToStr;
    method made(::?CLASS:D: --> Bool:D)
    {
        my Bool:D $made = $.make;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = 'true';
    }
}

role TOMLBoolean['False']
{
    also does Made;
    also does Make[Bool:D];
    also does ToStr;
    method made(::?CLASS:D: --> Bool:D)
    {
        my Bool:D $made = $.make;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = 'false';
    }
}

# end boolean }}}
# datetime {{{

role TOMLDate['DateTime']
{
    also does Made;
    also does Make[DateTime:D];
    also does ToStr;
    method made(::?CLASS:D: --> DateTime:D)
    {
        my DateTime:D $made = $.make;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = $.make.Str;
    }
}

role TOMLDate['DateTime', 'OmitLocalOffset']
{
    also does Made;
    also does Make[DateTime:D];
    also does ToStr;
    method made(::?CLASS:D: --> DateTime:D)
    {
        my DateTime:D $made = $.make;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $year = $.make.year;
        my Str:D $month = $.make.month;
        my Str:D $day = $.make.day;
        my Str:D $hour = $.make.hour;
        my Str:D $minute = $.make.minute;
        my Str:D $second = $.make.second;
        my Str:D $s =
            sprintf(
                Q{%04s-%02s-%02sT%02s:%02s:%02s},
                $year,
                $month,
                $day,
                $hour,
                $minute,
                $second
            );
    }
}

role TOMLDate['FullDate']
{
    also does Made;
    also does Make[Date:D];
    also does ToStr;
    method made(::?CLASS:D: --> Date:D)
    {
        my Date:D $made = $.make;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = $.make.Str;
    }
}

role TOMLTime
{
    also does Made;
    also does Make[Hash:D];
    also does ToStr;
    method made(::?CLASS:D: --> Hash:D)
    {
        my %made = $.make;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $hour = $.make.hour;
        my Str:D $minute = $.make.minute;
        my Str:D $second = $.make.second;
        my Str:D $s = sprintf(Q{%02s:%02s:%02s}, $hour, $minute, $second);
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
    also does ToStr;
    method made(::?CLASS:D: --> Array:D)
    {
        my @made = $.make.hyper.map({ .made });
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D @s = $.make.hyper.map({ .Str });
        my Str:D $s = @s.join(', ');
    }
}

role TOMLArrayElements['Integers']
{
    also does Made;
    also does Make[Array[TOMLInteger:D]];
    also does ToStr;
    method made(::?CLASS:D: --> Array:D)
    {
        my @made = $.make.hyper.map({ .made });
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D @s = $.make.hyper.map({ .Str });
        my Str:D $s = @s.join(', ');
    }
}

role TOMLArrayElements['Floats']
{
    also does Made;
    also does Make[Array[TOMLFloat:D]];
    also does ToStr;
    method made(::?CLASS:D: --> Array:D)
    {
        my @made = $.make.hyper.map({ .made });
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D @s = $.make.hyper.map({ .Str });
        my Str:D $s = @s.join(', ');
    }
}

role TOMLArrayElements['Booleans']
{
    also does Made;
    also does Make[Array[TOMLBoolean:D]];
    also does ToStr;
    method made(::?CLASS:D: --> Array:D)
    {
        my @made = $.make.hyper.map({ .made });
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D @s = $.make.hyper.map({ .Str });
        my Str:D $s = @s.join(', ');
    }
}

role TOMLArrayElements['Dates']
{
    also does Made;
    also does Make[Array[TOMLDate:D]];
    also does ToStr;
    method made(::?CLASS:D: --> Array:D)
    {
        my @made = $.make.hyper.map({ .made });
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D @s = $.make.hyper.map({ .Str });
        my Str:D $s = @s.join(', ');
    }
}

role TOMLArrayElements['Times']
{
    also does Made;
    also does Make[Array[TOMLTime:D]];
    also does ToStr;
    method made(::?CLASS:D: --> Array:D)
    {
        my @made = $.make.hyper.map({ .made });
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D @s = $.make.hyper.map({ .Str });
        my Str:D $s = @s.join(', ');
    }
}

role TOMLArrayElements['Arrays']
{
    also does Made;
    also does Make[Array[TOMLArray:D]];
    also does ToStr;
    method made(::?CLASS:D: --> Array:D)
    {
        my @made = $.make.hyper.map({ .made });
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D @s = $.make.hyper.map({ .Str });
        my Str:D $s = @s.join(', ');
    }
}

role TOMLArrayElements['TableInlines']
{
    also does Made;
    also does Make[Array[TOMLTableInline:D]];
    also does ToStr;
    method made(::?CLASS:D: --> Array:D)
    {
        my @made = $.make.hyper.map({ .made });
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D @s = $.make.hyper.map({ .Str });
        my Str:D $s = @s.join(', ');
    }
}

role TOMLArrayElements['Empty']
{
    also does Made;
    also does Make[Array:D];
    also does ToStr;
    method made(::?CLASS:D: --> Array:D)
    {
        my @made;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = '';
    }
}

role TOMLArray
{
    also does Made;
    also does Make[TOMLArrayElements:D];
    also does ToStr;
    method made(::?CLASS:D: --> Array:D)
    {
        my @made = $.make.made;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = sprintf(Q{[%s]}, $.make.Str);
    }
}

# end array }}}
# table {{{

role TOMLKeypairKeySingleBare
{
    also does Made;
    also does Make[Str:D];
    also does ToStr;
    method made(::?CLASS:D: --> Str:D)
    {
        my Str:D $made = $.make;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = $.make;
    }
}

role TOMLKeypairKeySingle['Bare']
{
    also does Made;
    also does Make[TOMLKeypairKeySingleBare:D];
    also does ToStr;
    method made(::?CLASS:D: --> Array[Str:D])
    {
        my Str:D @made = $.make.made;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = $.make.Str;
    }
}

role TOMLKeypairKeySingleString['Basic']
{
    also does Made;
    also does Make[TOMLString['Basic']];
    also does ToStr;
    method made(::?CLASS:D: --> Str:D)
    {
        my Str:D $made = $.make.made;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = $.make.Str;
    }
}

role TOMLKeypairKeySingleString['Literal']
{
    also does Made;
    also does Make[TOMLString['Literal']];
    also does ToStr;
    method made(::?CLASS:D: --> Str:D)
    {
        my Str:D $made = $.make.made;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = $.make.Str;
    }
}

role TOMLKeypairKeySingle['Quoted']
{
    also does Made;
    also does Make[TOMLKeypairKeySingleString:D];
    also does ToStr;
    method made(::?CLASS:D: --> Array[Str:D])
    {
        my Str:D @made = $.make.made;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = $.make.Str;
    }
}

role TOMLKeypairKey['Single']
{
    also does Made;
    also does Make[TOMLKeypairKeySingle:D];
    also does ToStr;
    method made(::?CLASS:D: --> Array[Str:D])
    {
        my Str:D @made = $.make.made;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = $.make.Str;
    }
}

role TOMLKeypairKeyDotted
{
    also does Made;
    also does Make[Array[TOMLKeypairKeySingle:D]];
    also does ToStr;
    method made(::?CLASS:D: --> Array[Str:D])
    {
        my Str:D @made = $.make.hyper.map({ .made }).flat;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D @s = $.make.hyper.map({ .Str });
        my Str:D $s = @s.join('.');
    }
}

role TOMLKeypairKey['Dotted']
{
    also does Made;
    also does Make[TOMLKeypairKeyDotted:D];
    also does ToStr;
    method made(::?CLASS:D: --> Array[Str:D])
    {
        my Str:D @made = $.make.made;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = $.make.Str;
    }
}

role TOMLKeypairValue['String']
{
    also does Made;
    also does Make[TOMLString:D];
    also does ToStr;
    method made(::?CLASS:D: --> Str:D)
    {
        my Str:D $made = $.make.made;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = $.make.Str;
    }
}

role TOMLKeypairValue['Number']
{
    also does Made;
    also does Make[TOMLNumber:D];
    also does ToStr;
    method made(::?CLASS:D: --> Numeric:D)
    {
        my Numeric:D $made = $.make.made;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = $.make.Str;
    }
}

role TOMLKeypairValue['Boolean']
{
    also does Made;
    also does Make[TOMLBoolean:D];
    also does ToStr;
    method made(::?CLASS:D: --> Bool:D)
    {
        my Bool:D $made = $.make.made;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = $.make.Str;
    }
}

role TOMLKeypairValue['Date']
{
    also does Made;
    also does Make[TOMLDate:D];
    also does ToStr;
    method made(::?CLASS:D: --> Dateish:D)
    {
        my Dateish:D $made = $.make.made;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = $.make.Str;
    }
}

role TOMLKeypairValue['Array']
{
    also does Made;
    also does Make[TOMLArray:D];
    also does ToStr;
    method made(::?CLASS:D: --> Array:D)
    {
        my @made = $.make.made;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = $.make.Str;
    }
}

role TOMLKeypairValue['TableInline']
{
    also does Made;
    also does Make[TOMLTableInline:D];
    also does ToStr;
    method made(::?CLASS:D: --> Array:D)
    {
        my @made = $.make.made;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = $.make.Str;
    }
}

role TOMLKeypair
{
    also does Made;
    also does Make[Hash[TOMLKeypairValue:D,TOMLKeypairKey:D]];
    also does ToStr;
    method made(::?CLASS:D: --> Hash[Any:D,Array[Str:D]])
    {
        my Str:D @k = $.make.keys.first.made;
        my $v = $.make.values.first.made;
        my Any:D %made{Array[Str:D]} = @k => $v;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $k = $.make.keys.first.Str;
        my Str:D $v = $.make.values.first.Str;
        my Str:D $s = sprintf(Q{%s = %s}, $k, $v);
    }
}

role TOMLTableInlineKeypairs['Populated']
{
    also does Made;
    also does Make[Array[TOMLKeypair:D]];
    also does ToStr;
    method made(::?CLASS:D: --> Array[Hash[Any:D,Array[Str:D]]])
    {
        my Hash[Any:D,Array[Str:D]] @made = $.make.hyper.map({ .made });
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D @s = $.make.hyper.map({ .Str });
        my Str:D $s = @s.join(', ');
    }
}

role TOMLTableInlineKeypairs['Empty']
{
    also does Made;
    also does Make[Array:D];
    also does ToStr;
    method made(::?CLASS:D: --> Array[Hash[Any:D,Array[Str:D]]])
    {
        my Hash[Any:D,Array[Str:D]] @made;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = '';
    }
}

role TOMLTableInline
{
    also does Made;
    also does Make[TOMLTableInlineKeypairs:D];
    also does ToStr;
    method made(::?CLASS:D: --> Array[Hash[Any:D,Array[Str:D]]])
    {
        my Hash[Any:D,Array[Str:D]] @made = $.make.made;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = sprintf(Q<{%s}>, $.make.Str);
    }
}

# end table }}}
# document {{{

role TOMLKeypairLine
{
    also does Made;
    also does Make[TOMLKeypair:D];
    also does ToStr;
    method made(::?CLASS:D: --> Hash[Any:D,Array[Str:D]])
    {
        my Any:D %made{Array[Str:D]} = $.make.made;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = $.make.Str;
    }
}

role TOMLKeypairLines['Populated']
{
    also does Made;
    also does Make[Array[TOMLKeypairLine:D]];
    also does ToStr;
    method made(::?CLASS:D: --> Array[Hash[Any:D,Array[Str:D]]])
    {
        my Hash[Any:D,Array[Str:D]] @made = $.make.hyper.map({ .made });
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D @s = $.make.hyper.map({ .Str });
        my Str:D $s = @s.join("\n");
    }
}

role TOMLKeypairLines['Empty']
{
    also does Made;
    also does Make[Array:D];
    also does ToStr;
    method made(::?CLASS:D: --> Array[Hash[Any:D,Array[Str:D]]])
    {
        my Hash[Any:D,Array[Str:D]] @made;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = '';
    }
}

role TOMLTableHeaderText
{
    also does Made;
    also does Make[Array[TOMLKeypairKeySingle:D]];
    also does ToStr;
    method made(::?CLASS:D: --> Array[Str:D])
    {
        my Str:D @made = $.make.hyper.map({ .made }).flat;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D @s = $.make.hyper.map({ .Str });
        my Str:D $s = @s.join('.');
    }
}

role TOMLHOHHeader
{
    also does Made;
    also does Make[TOMLTableHeaderText:D];
    also does ToStr;
    method made(::?CLASS:D: --> Array[Str:D])
    {
        my Str:D @made = $.make.made;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = sprintf(Q{[%s]}, $.make.Str);
    }
}

role TOMLTable['HOH']
{
    also does Made;
    also does Make[Hash[TOMLKeypairLines:D,TOMLHOHHeader:D]];
    also does ToStr;
    method made(
        ::?CLASS:D:
        --> Hash[Array[Hash[Any:D,Array[Str:D]]],Array[Str:D]]
    )
    {
        my Str:D @key = $.make.keys.first.made;
        my Hash[Any:D,Array[Str:D]] @value = $.make.values.first.made;
        my Array[Hash[Any:D,Array[Str:D]]] %made{Array[Str:D]} = @key => @value;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $h = $.make.keys.first.Str;
        my Str:D $l = $.make.values.first.Str;
        my Str:D $s = sprintf(qq{%s\n%s}, $h, $l);
    }
}

role TOMLAOHHeader
{
    also does Made;
    also does Make[TOMLTableHeaderText:D];
    also does ToStr;
    method made(::?CLASS:D: --> Array[Str:D])
    {
        my Str:D @made = $.make.made;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = sprintf(Q{[[%s]]}, $.make.Str);
    }
}

role TOMLTable['AOH']
{
    also does Made;
    also does Make[Hash[TOMLKeypairLines:D,TOMLAOHHeader:D]];
    also does ToStr;
    method made(
        ::?CLASS:D:
        --> Hash[Array[Hash[Any:D,Array[Str:D]]],Array[Str:D]]
    )
    {
        my Str:D @key = $.make.keys.first.made;
        my Hash[Any:D,Array[Str:D]] @value = $.make.values.first.made;
        my Array[Hash[Any:D,Array[Str:D]]] %made{Array[Str:D]} = @key => @value;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $h = $.make.keys.first.Str;
        my Str:D $l = $.make.values.first.Str;
        my Str:D $s = sprintf(qq{%s\n%s}, $h, $l);
    }
}

role TOMLSegment['KeypairLine']
{
    also does Made;
    also does Make[TOMLKeypairLine:D];
    also does ToStr;
    method made(
        ::?CLASS:D:
        --> Hash[Array[Hash[Any:D,Array[Str:D]]],Array[Str:D]]
    )
    {
        my Str:D @k;
        my Any:D %k{Array[Str:D]} = $.make.made;
        my Hash[Any:D,Array[Str:D]] @v = %k,;
        my Array[Hash[Any:D,Array[Str:D]]] %made{Array[Str:D]} = @k => @v;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = $.make.Str;
    }
}

role TOMLSegment['Table']
{
    also does Made;
    also does Make[TOMLTable:D];
    also does ToStr;
    method made(
        ::?CLASS:D:
        --> Hash[Array[Hash[Any:D,Array[Str:D]]],Array[Str:D]]
    )
    {
        my Str:D @key = $.make.made.keys.first;
        my Hash[Any:D,Array[Str:D]] @value = |$.make.made.values.first;
        my Array[Hash[Any:D,Array[Str:D]]] %made{Array[Str:D]} = @key => @value;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = $.make.Str;
    }
}

role TOMLDocument['Populated']
{
    also does Made;
    also does Make[Array[TOMLSegment:D]];
    also does ToStr;
    method made(
        ::?CLASS:D:
        --> Array[Hash[Array[Hash[Any:D,Array[Str:D]]],Array[Str:D]]]
    )
    {
        my Hash[Array[Hash[Any:D,Array[Str:D]]],Array[Str:D]] @made =
            $.make.hyper.map({ .made });
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D @s = $.make.hyper.map({ .Str });
        my Str:D $s = @s.join("\n");
    }
}

role TOMLDocument['Empty']
{
    also does Made;
    also does Make[Array:D];
    also does ToStr;
    method made(
        ::?CLASS:D:
        --> Array[Hash[Array[Hash[Any:D,Array[Str:D]]],Array[Str:D]]]
    )
    {
        my Hash[Array[Hash[Any:D,Array[Str:D]]],Array[Str:D]] @made;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = '';
    }
}

role TOML
{
    also does Made;
    also does Make[TOMLDocument:D];
    also does ToStr;
    method made(
        ::?CLASS:D:
        --> Array[Hash[Array[Hash[Any:D,Array[Str:D]]],Array[Str:D]]]
    )
    {
        my Hash[Array[Hash[Any:D,Array[Str:D]]],Array[Str:D]] @b = $.make.made;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = $.make.Str;
    }
}

# end document }}}

# vim: set filetype=perl6 foldmethod=marker foldlevel=0:
