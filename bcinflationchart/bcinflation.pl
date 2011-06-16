#!/usr/bin/perl
# 3456789#123456789#123456789#123456789#123456789#123456789#123456789#123456789#
# bcinflation.pl 20101228 jeffrey paul <sneak@datavibe.net> 
# 5539 AD00 DE4C 42F3 AFE1  1575 0524 43F4 DF2A 55C2  # please sign!

use strict;
use warnings qw( all );
use LWP::Simple;
use Data::Dumper;
use HTML::Strip;
use DateTime;

# thanks to nullvoid for historical block data
my $historyurl = 'http://nullvoid.org/bitcoin/difficultiez.php';
my $growthfactor = 1.0;

main();

sub main {
	my $hist = fetch_history_data() or die "unable to fetch history!";
	my $block = 0;
	my $totalbc = 0;
	my $perblock = 50;
	my $at = 1231006505; # block zero timestamp
	while ($block < 1500000) { # arbitrary
		$block++;
		$perblock /= 2 unless $block % 210000;
		$at += 60*10/$growthfactor; # estimate block timestamp
		# replace with real data if we have it:
		$at = $hist->{$block} if exists($hist->{$block});
		$totalbc += $perblock;
		if ($block == 210000) {
			print ts2nice($at);
			die;
		}
	unless($block % 21000) {
			print ts2nice($at) . ",";
			print $block . ",";
			print $perblock . ",";
			print $totalbc. ",";
			print "\n";
		}
	}
}

sub ts2nice { return DateTime->from_epoch( epoch => shift() )->ymd; }

sub fetch_history_data {
	my $raw = get($historyurl) or die "derp: $!";

	my $clean = HTML::Strip->new()->parse($raw);
	$clean =~ s/Block/\nBlock/g;
	my $out = {};
	foreach my $l (split(/\n+/,$clean)) {
		next unless $l =~ /^Block\s+([0-9]+)\s+was.*at\s+([0-9]+).*Difficulty\:\s+([0-9\.]{3,10}).*$/;
		$out->{$1} = $2;	
	}
	return unless $out->{98784};
	return $out;
}

1;
__END__
