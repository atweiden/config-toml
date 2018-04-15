use v6;
use Crane;

# helper {{{

my role Made { method made() {...} }
my role Make[::T] { has T $.make is required }
my role ToHash { method hash() {...} }
my role ToStr { method Str() {...} }
# catch-all for unrolling TOML roles into native P6 containers
my role Tree { method tree() {...} }

# end helper }}}

# string {{{

role TOMLString['Basic']
{
    also does Made;
    also does Make[Str:D];
    also does ToStr;
    also does Tree;
    method made(::?CLASS:D: --> Str:D)
    {
        my Str:D $made = $.make;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = sprintf(Q{"%s"}, $.make.subst('"', '\"', :g));
    }
    method tree(::?CLASS:D: --> Any:D)
    {
        my $tree = self.made;
    }
}

role TOMLString['Basic', 'Multiline']
{
    also does Made;
    also does Make[Str:D];
    also does ToStr;
    also does Tree;
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
    method tree(::?CLASS:D: --> Any:D)
    {
        my $tree = self.made;
    }
}

role TOMLString['Literal']
{
    also does Made;
    also does Make[Str:D];
    also does ToStr;
    also does Tree;
    method made(::?CLASS:D: --> Str:D)
    {
        my Str:D $made = $.make;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = sprintf(Q{'%s'}, $.make);
    }
    method tree(::?CLASS:D: --> Any:D)
    {
        my $tree = self.made;
    }
}

role TOMLString['Literal', 'Multiline']
{
    also does Made;
    also does Make[Str:D];
    also does ToStr;
    also does Tree;
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
    method tree(::?CLASS:D: --> Any:D)
    {
        my $tree = self.made;
    }
}

# end string }}}
# number {{{

role TOMLFloat['Common']
{
    also does Made;
    also does Make[Numeric:D];
    also does ToStr;
    also does Tree;
    method made(::?CLASS:D: --> Numeric:D)
    {
        my Numeric:D $made = $.make;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = $.make.Str;
    }
    method tree(::?CLASS:D: --> Any:D)
    {
        my $tree = self.made;
    }
}

role TOMLFloat['Inf']
{
    also does Made;
    also does Make[Numeric:D];
    also does ToStr;
    also does Tree;
    method made(::?CLASS:D: --> Numeric:D)
    {
        my Numeric:D $made = $.make;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = 'inf';
    }
    method tree(::?CLASS:D: --> Any:D)
    {
        my $tree = self.made;
    }
}

role TOMLFloat['NaN']
{
    also does Made;
    also does Make[Numeric:D];
    also does ToStr;
    also does Tree;
    method made(::?CLASS:D: --> Numeric:D)
    {
        my Numeric:D $made = $.make;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = 'nan';
    }
    method tree(::?CLASS:D: --> Any:D)
    {
        my $tree = self.made;
    }
}

role TOMLInteger['Common']
{
    also does Made;
    also does Make[Int:D];
    also does ToStr;
    also does Tree;
    method made(::?CLASS:D: --> Int:D)
    {
        my Int:D $made = $.make;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = $.make.Str;
    }
    method tree(::?CLASS:D: --> Any:D)
    {
        my $tree = self.made;
    }
}

role TOMLInteger['Binary']
{
    also does Made;
    also does Make[Int:D];
    also does ToStr;
    also does Tree;
    method made(::?CLASS:D: --> Int:D)
    {
        my Int:D $made = $.make;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = sprintf(Q{0b%s}, $.make.base(2).Str);
    }
    method tree(::?CLASS:D: --> Any:D)
    {
        my $tree = self.made;
    }
}

role TOMLInteger['Hexadecimal']
{
    also does Made;
    also does Make[Int:D];
    also does ToStr;
    also does Tree;
    method made(::?CLASS:D: --> Int:D)
    {
        my Int:D $made = $.make;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = sprintf(Q{0x%s}, $.make.base(16).Str);
    }
    method tree(::?CLASS:D: --> Any:D)
    {
        my $tree = self.made;
    }
}

role TOMLInteger['Octal']
{
    also does Made;
    also does Make[Int:D];
    also does ToStr;
    also does Tree;
    method made(::?CLASS:D: --> Int:D)
    {
        my Int:D $made = $.make;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = sprintf(Q{0o%s}, $.make.base(8).Str);
    }
    method tree(::?CLASS:D: --> Any:D)
    {
        my $tree = self.made;
    }
}

role TOMLNumber['Float']
{
    also does Made;
    also does Make[TOMLFloat:D];
    also does ToStr;
    also does Tree;
    method made(::?CLASS:D: --> Numeric:D)
    {
        my Numeric:D $made = $.make.made;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = $.make.Str;
    }
    method tree(::?CLASS:D: --> Any:D)
    {
        my $tree = self.made;
    }
}

role TOMLNumber['Integer']
{
    also does Made;
    also does Make[TOMLInteger:D];
    also does ToStr;
    also does Tree;
    method made(::?CLASS:D: --> Int:D)
    {
        my Int:D $made = $.make.made;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = $.make.Str;
    }
    method tree(::?CLASS:D: --> Any:D)
    {
        my $tree = self.made;
    }
}

# end number }}}
# boolean {{{

role TOMLBoolean['True']
{
    also does Made;
    also does Make[Bool:D];
    also does ToStr;
    also does Tree;
    method made(::?CLASS:D: --> Bool:D)
    {
        my Bool:D $made = $.make;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = 'true';
    }
    method tree(::?CLASS:D: --> Any:D)
    {
        my $tree = self.made;
    }
}

role TOMLBoolean['False']
{
    also does Made;
    also does Make[Bool:D];
    also does ToStr;
    also does Tree;
    method made(::?CLASS:D: --> Bool:D)
    {
        my Bool:D $made = $.make;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = 'false';
    }
    method tree(::?CLASS:D: --> Any:D)
    {
        my $tree = self.made;
    }
}

# end boolean }}}
# datetime {{{

role TOMLDate['DateTime']
{
    also does Made;
    also does Make[DateTime:D];
    also does ToStr;
    also does Tree;
    method made(::?CLASS:D: --> DateTime:D)
    {
        my DateTime:D $made = $.make;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = $.make.Str;
    }
    method tree(::?CLASS:D: --> Any:D)
    {
        my $tree = self.made;
    }
}

role TOMLDate['DateTime', 'OmitLocalOffset']
{
    also does Made;
    also does Make[DateTime:D];
    also does ToStr;
    also does Tree;
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
    method tree(::?CLASS:D: --> Any:D)
    {
        my $tree = self.made;
    }
}

role TOMLDate['FullDate']
{
    also does Made;
    also does Make[Date:D];
    also does ToStr;
    also does Tree;
    method made(::?CLASS:D: --> Date:D)
    {
        my Date:D $made = $.make;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = $.make.Str;
    }
    method tree(::?CLASS:D: --> Any:D)
    {
        my $tree = self.made;
    }
}

role TOMLTime
{
    also does Made;
    also does Make[Hash:D];
    also does ToStr;
    also does Tree;
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
    method tree(::?CLASS:D: --> Any:D)
    {
        my $tree = self.made;
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
    also does Tree;
    method made(::?CLASS:D: --> Array:D)
    {
        my @made = $.make.hyper.map({ .made });
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D @s = $.make.hyper.map({ .Str });
        my Str:D $s = @s.join(', ');
    }
    method tree(::?CLASS:D: --> Any:D)
    {
        my $tree = self.made;
    }
}

role TOMLArrayElements['Integers']
{
    also does Made;
    also does Make[Array[TOMLInteger:D]];
    also does ToStr;
    also does Tree;
    method made(::?CLASS:D: --> Array:D)
    {
        my @made = $.make.hyper.map({ .made });
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D @s = $.make.hyper.map({ .Str });
        my Str:D $s = @s.join(', ');
    }
    method tree(::?CLASS:D: --> Any:D)
    {
        my $tree = self.made;
    }
}

role TOMLArrayElements['Floats']
{
    also does Made;
    also does Make[Array[TOMLFloat:D]];
    also does ToStr;
    also does Tree;
    method made(::?CLASS:D: --> Array:D)
    {
        my @made = $.make.hyper.map({ .made });
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D @s = $.make.hyper.map({ .Str });
        my Str:D $s = @s.join(', ');
    }
    method tree(::?CLASS:D: --> Any:D)
    {
        my $tree = self.made;
    }
}

role TOMLArrayElements['Booleans']
{
    also does Made;
    also does Make[Array[TOMLBoolean:D]];
    also does ToStr;
    also does Tree;
    method made(::?CLASS:D: --> Array:D)
    {
        my @made = $.make.hyper.map({ .made });
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D @s = $.make.hyper.map({ .Str });
        my Str:D $s = @s.join(', ');
    }
    method tree(::?CLASS:D: --> Any:D)
    {
        my $tree = self.made;
    }
}

role TOMLArrayElements['Dates']
{
    also does Made;
    also does Make[Array[TOMLDate:D]];
    also does ToStr;
    also does Tree;
    method made(::?CLASS:D: --> Array:D)
    {
        my @made = $.make.hyper.map({ .made });
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D @s = $.make.hyper.map({ .Str });
        my Str:D $s = @s.join(', ');
    }
    method tree(::?CLASS:D: --> Any:D)
    {
        my $tree = self.made;
    }
}

role TOMLArrayElements['Times']
{
    also does Made;
    also does Make[Array[TOMLTime:D]];
    also does ToStr;
    also does Tree;
    method made(::?CLASS:D: --> Array:D)
    {
        my @made = $.make.hyper.map({ .made });
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D @s = $.make.hyper.map({ .Str });
        my Str:D $s = @s.join(', ');
    }
    method tree(::?CLASS:D: --> Any:D)
    {
        my $tree = self.made;
    }
}

role TOMLArrayElements['Arrays']
{
    also does Made;
    also does Make[Array[TOMLArray:D]];
    also does ToStr;
    also does Tree;
    method made(::?CLASS:D: --> Array:D)
    {
        my @made = $.make.hyper.map({ .made });
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D @s = $.make.hyper.map({ .Str });
        my Str:D $s = @s.join(', ');
    }
    method tree(::?CLASS:D: --> Any:D)
    {
        my $tree = self.made;
    }
}

role TOMLArrayElements['TableInlines']
{
    also does Made;
    also does Make[Array[TOMLTableInline:D]];
    also does ToStr;
    also does Tree;
    method made(::?CLASS:D: --> Array:D)
    {
        my @made = $.make.hyper.map({ .made });
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D @s = $.make.hyper.map({ .Str });
        my Str:D $s = @s.join(', ');
    }
    method tree(::?CLASS:D: --> Any:D)
    {
        my $tree = self.made;
    }
}

role TOMLArrayElements['Empty']
{
    also does Made;
    also does Make[Array:D];
    also does ToStr;
    also does Tree;
    method made(::?CLASS:D: --> Array:D)
    {
        my @made;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = '';
    }
    method tree(::?CLASS:D: --> Any:D)
    {
        my $tree = self.made;
    }
}

role TOMLArray
{
    also does Made;
    also does Make[TOMLArrayElements:D];
    also does ToStr;
    also does Tree;
    method made(::?CLASS:D: --> Array:D)
    {
        my @made = $.make.made;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = sprintf(Q{[%s]}, $.make.Str);
    }
    method tree(::?CLASS:D: --> Any:D)
    {
        my $tree = self.made;
    }
}

# end array }}}
# table {{{

role TOMLKeypairKeySingleBare
{
    also does Made;
    also does Make[Str:D];
    also does ToStr;
    also does Tree;
    method made(::?CLASS:D: --> Str:D)
    {
        my Str:D $made = $.make;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = $.make;
    }
    method tree(::?CLASS:D: --> Any:D)
    {
        my $tree = self.made;
    }
}

role TOMLKeypairKeySingle['Bare']
{
    also does Made;
    also does Make[TOMLKeypairKeySingleBare:D];
    also does ToStr;
    also does Tree;
    method made(::?CLASS:D: --> Array[Str:D])
    {
        my Str:D @made = $.make.made;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = $.make.Str;
    }
    method tree(::?CLASS:D: --> Any:D)
    {
        my $tree = self.made;
    }
}

role TOMLKeypairKeySingleString['Basic']
{
    also does Made;
    also does Make[TOMLString['Basic']];
    also does ToStr;
    also does Tree;
    method made(::?CLASS:D: --> Str:D)
    {
        my Str:D $made = $.make.made;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = $.make.Str;
    }
    method tree(::?CLASS:D: --> Any:D)
    {
        my $tree = self.made;
    }
}

role TOMLKeypairKeySingleString['Literal']
{
    also does Made;
    also does Make[TOMLString['Literal']];
    also does ToStr;
    also does Tree;
    method made(::?CLASS:D: --> Str:D)
    {
        my Str:D $made = $.make.made;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = $.make.Str;
    }
    method tree(::?CLASS:D: --> Any:D)
    {
        my $tree = self.made;
    }
}

role TOMLKeypairKeySingle['Quoted']
{
    also does Made;
    also does Make[TOMLKeypairKeySingleString:D];
    also does ToStr;
    also does Tree;
    method made(::?CLASS:D: --> Array[Str:D])
    {
        my Str:D @made = $.make.made;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = $.make.Str;
    }
    method tree(::?CLASS:D: --> Any:D)
    {
        my $tree = self.made;
    }
}

role TOMLKeypairKey['Single']
{
    also does Made;
    also does Make[TOMLKeypairKeySingle:D];
    also does ToStr;
    also does Tree;
    method made(::?CLASS:D: --> Array[Str:D])
    {
        my Str:D @made = $.make.made;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = $.make.Str;
    }
    method tree(::?CLASS:D: --> Any:D)
    {
        my $tree = self.made;
    }
}

role TOMLKeypairKeyDotted
{
    also does Made;
    also does Make[Array[TOMLKeypairKeySingle:D]];
    also does ToStr;
    also does Tree;
    method made(::?CLASS:D: --> Array[Str:D])
    {
        my Str:D @made = $.make.hyper.map({ .made }).flat;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D @s = $.make.hyper.map({ .Str });
        my Str:D $s = @s.join('.');
    }
    method tree(::?CLASS:D: --> Any:D)
    {
        my $tree = self.made;
    }
}

role TOMLKeypairKey['Dotted']
{
    also does Made;
    also does Make[TOMLKeypairKeyDotted:D];
    also does ToStr;
    also does Tree;
    method made(::?CLASS:D: --> Array[Str:D])
    {
        my Str:D @made = $.make.made;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = $.make.Str;
    }
    method tree(::?CLASS:D: --> Any:D)
    {
        my $tree = self.made;
    }
}

role TOMLKeypairValue['String']
{
    also does Made;
    also does Make[TOMLString:D];
    also does ToStr;
    also does Tree;
    method made(::?CLASS:D: --> Str:D)
    {
        my Str:D $made = $.make.made;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = $.make.Str;
    }
    method tree(::?CLASS:D: --> Any:D)
    {
        my $tree = self.made;
    }
}

role TOMLKeypairValue['Number']
{
    also does Made;
    also does Make[TOMLNumber:D];
    also does ToStr;
    also does Tree;
    method made(::?CLASS:D: --> Numeric:D)
    {
        my Numeric:D $made = $.make.made;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = $.make.Str;
    }
    method tree(::?CLASS:D: --> Any:D)
    {
        my $tree = self.made;
    }
}

role TOMLKeypairValue['Boolean']
{
    also does Made;
    also does Make[TOMLBoolean:D];
    also does ToStr;
    also does Tree;
    method made(::?CLASS:D: --> Bool:D)
    {
        my Bool:D $made = $.make.made;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = $.make.Str;
    }
    method tree(::?CLASS:D: --> Any:D)
    {
        my $tree = self.made;
    }
}

role TOMLKeypairValue['Date']
{
    also does Made;
    also does Make[TOMLDate:D];
    also does ToStr;
    also does Tree;
    method made(::?CLASS:D: --> Dateish:D)
    {
        my Dateish:D $made = $.make.made;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = $.make.Str;
    }
    method tree(::?CLASS:D: --> Any:D)
    {
        my $tree = self.made;
    }
}

role TOMLKeypairValue['Array']
{
    also does Made;
    also does Make[TOMLArray:D];
    also does ToStr;
    also does Tree;
    method made(::?CLASS:D: --> Array:D)
    {
        my @made = $.make.made;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = $.make.Str;
    }
    method tree(::?CLASS:D: --> Any:D)
    {
        my $tree = self.made;
    }
}

role TOMLKeypairValue['TableInline']
{
    also does Made;
    also does Make[TOMLTableInline:D];
    also does ToStr;
    also does Tree;
    method made(::?CLASS:D: --> Array:D)
    {
        my @made = $.make.made;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = $.make.Str;
    }
    method tree(::?CLASS:D: --> Any:D)
    {
        my $tree = self.made;
    }
}

role TOMLKeypair
{
    also does Made;
    also does Make[Hash[TOMLKeypairValue:D,TOMLKeypairKey:D]];
    also does ToHash;
    also does ToStr;
    also does Tree;
    method hash(::?CLASS:D: --> Hash:D)
    {
        my %hash;
        my Str:D @path = $.make.keys.first.made;
        my $value = $.make.values.first.made;
        Crane.set(%hash, :@path, :$value);
        %hash;
    }
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
    method tree(::?CLASS:D: --> Any:D)
    {
        my $tree = self.hash;
    }
}

role TOMLTableInlineKeypairs['Populated']
{
    also does Made;
    also does Make[Array[TOMLKeypair:D]];
    also does ToHash;
    also does ToStr;
    also does Tree;
    method hash(::?CLASS:D: --> Hash:D)
    {
        my %hash;
        $.make.hyper.map(-> TOMLKeypair:D $k {
            my Str:D @path = $k.keys.first.made;
            my $value = $k.values.first.made;
            Crane.set(%hash, :@path, :$value);
        });
        %hash;
    }
    method made(::?CLASS:D: --> Array[Hash[Any:D,Array[Str:D]]])
    {
        my Hash[Any:D,Array[Str:D]] @made = $.make.hyper.map({ .made });
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D @s = $.make.hyper.map({ .Str });
        my Str:D $s = @s.join(', ');
    }
    method tree(::?CLASS:D: --> Any:D)
    {
        my $tree = self.hash;
    }
}

role TOMLTableInlineKeypairs['Empty']
{
    also does Made;
    also does Make[Array:D];
    also does ToHash;
    also does ToStr;
    also does Tree;
    method hash(::?CLASS:D: --> Hash:D)
    {
        my %hash;
    }
    method made(::?CLASS:D: --> Array[Hash[Any:D,Array[Str:D]]])
    {
        my Hash[Any:D,Array[Str:D]] @made;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = '';
    }
    method tree(::?CLASS:D: --> Any:D)
    {
        my $tree = self.hash;
    }
}

role TOMLTableInline
{
    also does Made;
    also does Make[TOMLTableInlineKeypairs:D];
    also does ToHash;
    also does ToStr;
    also does Tree;
    method hash(::?CLASS:D: --> Hash:D)
    {
        my %hash = $.make.hash;
    }
    method made(::?CLASS:D: --> Array[Hash[Any:D,Array[Str:D]]])
    {
        my Hash[Any:D,Array[Str:D]] @made = $.make.made;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = sprintf(Q<{%s}>, $.make.Str);
    }
    method tree(::?CLASS:D: --> Any:D)
    {
        my $tree = self.hash;
    }
}

# end table }}}
# document {{{

role TOMLKeypairLine
{
    also does Made;
    also does Make[TOMLKeypair:D];
    also does ToHash;
    also does ToStr;
    also does Tree;
    method hash(::?CLASS:D: --> Hash:D)
    {
        my %hash = $.make.hash;
    }
    method made(::?CLASS:D: --> Hash[Any:D,Array[Str:D]])
    {
        my Any:D %made{Array[Str:D]} = $.make.made;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = $.make.Str;
    }
    method tree(::?CLASS:D: --> Any:D)
    {
        my $tree = self.hash;
    }
}

role TOMLKeypairLines['Populated']
{
    also does Made;
    also does Make[Array[TOMLKeypairLine:D]];
    also does ToHash;
    also does ToStr;
    also does Tree;
    method hash(::?CLASS:D: --> Hash:D)
    {
        my %hash;
        $.make.hyper.map(-> TOMLKeypairLine:D $k {
            my Str:D @path = $k.keys.first.made;
            my $value = $k.values.first.made;
            Crane.set(%hash, :@path, :$value);
        });
        %hash;
    }
    method made(::?CLASS:D: --> Array[Hash[Any:D,Array[Str:D]]])
    {
        my Hash[Any:D,Array[Str:D]] @made = $.make.hyper.map({ .made });
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D @s = $.make.hyper.map({ .Str });
        my Str:D $s = @s.join("\n");
    }
    method tree(::?CLASS:D: --> Any:D)
    {
        my $tree = self.hash;
    }
}

role TOMLKeypairLines['Empty']
{
    also does Made;
    also does Make[Array:D];
    also does ToHash;
    also does ToStr;
    also does Tree;
    method hash(::?CLASS:D: --> Hash:D)
    {
        my %hash;
    }
    method made(::?CLASS:D: --> Array[Hash[Any:D,Array[Str:D]]])
    {
        my Hash[Any:D,Array[Str:D]] @made;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = '';
    }
    method tree(::?CLASS:D: --> Any:D)
    {
        my $tree = self.hash;
    }
}

role TOMLTableHeaderText
{
    also does Made;
    also does Make[Array[TOMLKeypairKeySingle:D]];
    also does ToStr;
    also does Tree;
    method made(::?CLASS:D: --> Array[Str:D])
    {
        my Str:D @made = $.make.hyper.map({ .made }).flat;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D @s = $.make.hyper.map({ .Str });
        my Str:D $s = @s.join('.');
    }
    method tree(::?CLASS:D: --> Any:D)
    {
        my $tree = self.made;
    }
}

role TOMLHOHHeader
{
    also does Made;
    also does Make[TOMLTableHeaderText:D];
    also does ToStr;
    also does Tree;
    method made(::?CLASS:D: --> Array[Str:D])
    {
        my Str:D @made = $.make.made;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = sprintf(Q{[%s]}, $.make.Str);
    }
    method tree(::?CLASS:D: --> Any:D)
    {
        my $tree = self.made;
    }
}

role TOMLTable['HOH']
{
    also does Made;
    also does Make[Hash[TOMLKeypairLines:D,TOMLHOHHeader:D]];
    also does ToHash;
    also does ToStr;
    also does Tree;
    method hash(::?CLASS:D: --> Hash:D)
    {
        my %hash;
        my Str:D @path = $.make.keys.first.made;
        my %value = $.make.values.first.hash;
        Crane.set(%hash, :@path, :%value);
        %hash;
    }
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
    method tree(::?CLASS:D: --> Any:D)
    {
        my $tree = self.hash;
    }
}

role TOMLAOHHeader
{
    also does Made;
    also does Make[TOMLTableHeaderText:D];
    also does ToStr;
    also does Tree;
    method made(::?CLASS:D: --> Array[Str:D])
    {
        my Str:D @made = $.make.made;
    }
    method Str(::?CLASS:D: --> Str:D)
    {
        my Str:D $s = sprintf(Q{[[%s]]}, $.make.Str);
    }
    method tree(::?CLASS:D: --> Any:D)
    {
        my $tree = self.hash;
    }
}

role TOMLTable['AOH']
{
    also does Made;
    also does Make[Hash[TOMLKeypairLines:D,TOMLAOHHeader:D]];
    also does ToHash;
    also does ToStr;
    also does Tree;
    method hash(::?CLASS:D: --> Hash:D)
    {
        my %hash;
        my Str:D @path = $.make.keys.first.made;
        my %value = $.make.values.first.hash;
        Crane.set(%hash, :@path, :%value);
        %hash;
    }
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
    method tree(::?CLASS:D: --> Any:D)
    {
        my $tree = self.hash;
    }
}

role TOMLSegment['KeypairLine']
{
    also does Made;
    also does Make[TOMLKeypairLine:D];
    also does ToHash;
    also does ToStr;
    also does Tree;
    method hash(::?CLASS:D: --> Hash:D)
    {
        my %hash = $.make.hash;
    }
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
    method tree(::?CLASS:D: --> Any:D)
    {
        my $tree = self.hash;
    }
}

role TOMLSegment['Table']
{
    also does Made;
    also does Make[TOMLTable:D];
    also does ToHash;
    also does ToStr;
    also does Tree;
    method hash(::?CLASS:D: --> Hash:D)
    {
        my %hash = $.make.hash;
    }
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
    method tree(::?CLASS:D: --> Any:D)
    {
        my $tree = self.hash;
    }
}

role TOMLDocument['Populated']
{
    also does Made;
    also does Make[Array[TOMLSegment:D]];
    also does ToHash;
    also does ToStr;
    also does Tree;
    method hash(::?CLASS:D: --> Hash:D)
    {
        my %hash;
        $.make.hyper.map(-> TOMLSegment:D $s {
            my Array[Hash[Any:D,Array[Str:D]]] %h{Array[Str:D]} = $s.made;
            my Str:D @base-path = %h.keys.first;
            my Hash[Any:D,Array[Str:D]] @a = %h.values.first.flat;
            @a.hyper.map(-> %k {
                my Str:D @p = %k.keys.first;
                my Str:D @path = |@base-path, |@p;
                my $value = %k.values.first;
                Crane.set(%hash, :@path, :$value);
            })
        });
        %hash;
    }
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
    method tree(::?CLASS:D: --> Any:D)
    {
        my $tree = self.hash;
    }
}

role TOMLDocument['Empty']
{
    also does Made;
    also does Make[Array:D];
    also does ToHash;
    also does ToStr;
    also does Tree;
    method hash(::?CLASS:D: --> Hash:D)
    {
        my %hash;
    }
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
    method tree(::?CLASS:D: --> Any:D)
    {
        my $tree = self.hash;
    }
}

role TOML
{
    also does Made;
    also does Make[TOMLDocument:D];
    also does ToHash;
    also does ToStr;
    also does Tree;
    method hash(::?CLASS:D: --> Hash:D)
    {
        my %hash = $.make.hash;
    }
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
    method tree(::?CLASS:D: --> Any:D)
    {
        my $tree = self.hash;
    }
}

# end document }}}

# vim: set filetype=perl6 foldmethod=marker foldlevel=0:
