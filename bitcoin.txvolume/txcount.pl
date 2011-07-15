#!/usr/bin/perl
# 3456789#123456789#123456789#123456789#123456789#123456789#123456789#123456789#
# 20110715 jeffrey paul <sneak@datavibe.net> 
# 5539 AD00 DE4C 42F3 AFE1  1575 0524 43F4 DF2A 55C2  # please sign!
# thanks to theymos of bitcoin block explorer for txcount.csv export dump

use strict;
use warnings qw( all );
use DateTime;
use Data::Dumper;

sub main {
    open(DERP,'txcount.csv') or die;
    my $out = {};
    while(<DERP>) {
        chomp;
        next if /^#/;
        my @p = split(/,/);
        next unless @p == 3;
        my $dt = DateTime->from_epoch( epoch => $p[1] );
        $out->{$dt->ymd} += $p[2];
    }

    foreach (sort(keys(%$out))) {
        print $_ . "," . $out->{$_} . "\n";
    }
}

main();
