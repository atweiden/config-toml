Config::TOML
============

TOML parser for Rakudo Perl 6.


Usage
-----

```perl6
use Config::TOML;
my $toml_text = slurp 'config.toml';
my %toml = from-toml $toml_text;
```


Licensing
---------

This is free and unencumbered public domain software. For more
information, see http://unlicense.org/ or the accompanying UNLICENSE file.
