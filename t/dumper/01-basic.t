use v6;
use lib 'lib';
use Config::TOML;
use Test;

plan 1;

subtest
{
    my %h =
        :a({
            :b({
                :c([1, 2, 3]),
                :d(4, 5, 6)
            }),
            :e({
                :f<falcon>,
                :g<grandfather>
            }),
            :h([
                {
                    :xylophone({
                        :alpha([
                            {:m<alpha-multiple>},
                            {:l<alpha-levels>},
                            {:h<alpha-here>}
                        ])
                    })
                },
                {
                    :yakima({
                        :bravo([
                            {:m<bravo-multiple>},
                            {:l<bravo-levels>},
                            {:h<bravo-here>}
                        ])
                    })
                },
                {
                    :zoology({
                        :charlie([
                            {:m<charlie-multiple>},
                            {:l<charlie-levels>},
                            {:h<charlie-here>}
                        ])
                    })
                }
            ])
        }),
        :i<irene>;

    my Str $expected = q:to/EOF/;
    i = "irene"
    [a.b]
    c = [ 1, 2, 3 ]
    d = [ 4, 5, 6 ]
    [a.e]
    f = "falcon"
    g = "grandfather"
    [[a.h]]
    [[a.h.xylophone.alpha]]
    m = "alpha-multiple"
    [[a.h.xylophone.alpha]]
    l = "alpha-levels"
    [[a.h.xylophone.alpha]]
    h = "alpha-here"
    [[a.h]]
    [[a.h.yakima.bravo]]
    m = "bravo-multiple"
    [[a.h.yakima.bravo]]
    l = "bravo-levels"
    [[a.h.yakima.bravo]]
    h = "bravo-here"
    [[a.h]]
    [[a.h.zoology.charlie]]
    m = "charlie-multiple"
    [[a.h.zoology.charlie]]
    l = "charlie-levels"
    [[a.h.zoology.charlie]]
    h = "charlie-here"
    EOF
    $expected .= trim;

    my Str $toml = to-toml(%h);
    is $toml, $expected, 'Is expected value';
}

# vim: ft=perl6 fdm=marker fdl=0 nowrap
