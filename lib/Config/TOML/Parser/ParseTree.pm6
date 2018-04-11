use v6;

# helper {{{

role Made[::T] { has T $.made is required }

# end helper }}}

# string {{{

role TOMLString['Basic'] does Made[Str:D] {*}
role TOMLString['Basic', 'Multiline'] does Made[Str:D] {*}
role TOMLString['Literal'] does Made[Str:D] {*}
role TOMLString['Literal', 'Multiline'] does Made[Str:D] {*}

# end string }}}
# number {{{

role TOMLFloat['Common'] does Made[Numeric:D] {*}
role TOMLFloat['Inf'] does Made[Numeric:D] {*}
role TOMLFloat['NaN'] does Made[Numeric:D] {*}

role TOMLInteger['Common'] does Made[Int:D] {*}
role TOMLInteger['Binary'] does Made[Int:D] {*}
role TOMLInteger['Hexadecimal'] does Made[Int:D] {*}
role TOMLInteger['Octal'] does Made[Int:D] {*}

role TOMLNumber['Float'] does Made[TOMLFloat:D] {*}
role TOMLNumber['Integer'] does Made[TOMLInteger:D] {*}

# end number }}}
# boolean {{{

role TOMLBoolean['True'] does Made[Bool:D] {*}
role TOMLBoolean['False'] does Made[Bool:D] {*}

# end boolean }}}
# datetime {{{

role TOMLDate['DateTime'] does Made[DateTime:D] {*}
role TOMLDate['DateTime', 'OmitLocalOffset'] does Made[DateTime:D] {*}
role TOMLDate['FullDate'] does Made[Date:D] {*}
role TOMLDate['PartialTime'] does Made[Hash:D] {*}

# end datetime }}}
# array {{{

role TOMLArray {...}
role TOMLTableInline {...}

role TOMLArrayElements['Strings'] does Made[Array[TOMLString:D]] {*}
role TOMLArrayElements['Integers'] does Made[Array[TOMLInteger:D]] {*}
role TOMLArrayElements['Floats'] does Made[Array[TOMLFloat:D]] {*}
role TOMLArrayElements['Booleans'] does Made[Array[TOMLBoolean:D]] {*}
role TOMLArrayElements['Dates'] does Made[Array[TOMLDate:D]] {*}
role TOMLArrayElements['Arrays'] does Made[Array[TOMLArray:D]] {*}
role TOMLArrayElements['TableInlines'] does Made[Array[TOMLTableInline:D]] {*}
role TOMLArrayElements['Empty'] does Made[Array:D] {*}

role TOMLArray does Made[TOMLArrayElements:D] {*}

# end array }}}
# table {{{

role TOMLKeypairKeySingleBare does Made[Str:D] {*}
role TOMLKeypairKeySingle['Bare'] does Made[TOMLKeypairKeySingleBare:D] {*}
role TOMLKeypairKeySingleString['Basic'] does Made[TOMLString['Basic']] {*}
role TOMLKeypairKeySingleString['Literal'] does Made[TOMLString['Literal']] {*}
role TOMLKeypairKeySingle['Quoted'] does Made[TOMLKeypairKeySingleString:D] {*}
role TOMLKeypairKey['Single'] does Made[TOMLKeypairKeySingle:D] {*}

role TOMLKeypairKeyDotted does Made[Array[TOMLKeypairKeySingle:D]] {*}
role TOMLKeypairKey['Dotted'] does Made[TOMLKeypairKeyDotted:D] {*}

role TOMLKeypairValue['String'] does Made[TOMLString:D] {*}
role TOMLKeypairValue['Number'] does Made[TOMLNumber:D] {*}
role TOMLKeypairValue['Boolean'] does Made[TOMLBoolean:D] {*}
role TOMLKeypairValue['Date'] does Made[TOMLDate:D] {*}
role TOMLKeypairValue['Array'] does Made[TOMLArray:D] {*}
role TOMLKeypairValue['TableInline'] does Made[TOMLTableInline:D] {*}

role TOMLKeypair does Made[Hash[TOMLKeypairValue:D,TOMLKeypairKey:D]] {*}

role TOMLTableInlineKeypairs['Populated'] does Made[Array[TOMLKeypair:D]] {*}
role TOMLTableInlineKeypairs['Empty'] does Made[Array:D] {*}
role TOMLTableInline does Made[TOMLTableInlineKeypairs:D] {*}

# end table }}}
# document {{{

role TOMLKeypairLine does Made[TOMLKeypair:D] {*}
role TOMLKeypairLines['Populated'] does Made[Array[TOMLKeypairLine:D]] {*}
role TOMLKeypairLines['Empty'] does Made[Array:D] {*}

role TOMLTableHeaderText does Made[Array[TOMLKeypairKeySingle:D]] {*}

role TOMLHOHHeader does Made[TOMLTableHeaderText:D] {*}
role TOMLTable['HOH'] does Made[Hash[TOMLKeypairLines:D,TOMLHOHHeader:D]] {*}

role TOMLAOHHeader does Made[TOMLTableHeaderText:D] {*}
role TOMLTable['AOH'] does Made[Hash[TOMLKeypairLines:D,TOMLAOHHeader:D]] {*}

role TOMLSegment['KeypairLine'] does Made[TOMLKeypairLine:D] {*}
role TOMLSegment['Table'] does Made[TOMLTable:D] {*}

role TOMLDocument['Populated'] does Made[Array[TOMLSegment:D]] {*}
role TOMLDocument['Empty'] does Made[Array:D] {*}

role TOML does Made[TOMLDocument:D] {*}

# end document }}}

# vim: set filetype=perl6 foldmethod=marker foldlevel=0:
