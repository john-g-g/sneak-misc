#!/usr/bin/perl

use warnings qw( all );
use strict;
use DateTime;
use Data::Dumper;

main();

sub main {
    my $days;
    while(<>) {
       chomp;
       my @parts = split(/\,/);
       my $dt = DateTime->from_epoch( epoch => $parts[0] );
       $dt = dt2ymd($dt);
       print STDERR "setting $dt to " . $parts[1] . "\n";
       $days->{$dt} = $parts[1] + 0;
    }
    foreach (sort(keys(%$days))) {
        print "$_," . $days->{$_} . "\n";
    }
}

sub dt2ymd {
    my $dt = shift;
    return $dt->ymd('-');
}

