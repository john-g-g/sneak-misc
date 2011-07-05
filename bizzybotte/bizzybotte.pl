use strict;
use warnings qw( all );
use vars qw($VERSION %IRSSI);

use Irssi;
$VERSION = '20070322';
%IRSSI = (
    authors     => 'sneak for #bantown',
    contact     => 'sneak@datavibe.net',
    name        => 'bizzybotte',
    description => 'this script makes you sound like bizzy.',
    license => 'Public Domain',
);

sub send_text {

    #"send text", char *line, SERVER_REC, WI_ITEM_REC
    my ( $data, $server, $witem ) = @_;
    if ( $witem
        && ( $witem->{type} eq "CHANNEL" )
	&& $data
    )
    {
        $witem->command("msg $witem->{name} " . fuckestring($data));
        Irssi::signal_stop();
    }
}

sub fuckestring ($) {
	my $string;
	if(@_) {
		$string = shift;
	} else {
		$string = $_;
	}
	return '' unless $string;
	my @things = parseline($string);
	my $out;
	foreach my $thing (@things) {
		if($thing->{'type'} eq 'word') {
			my $word = suffixword($thing->{'content'});
			$word = uc($word)
				if
				uc($thing->{'content'}) eq $thing->{'content'};
			$out .= $word;
		} else {
			$out .= $thing->{'content'};
		}
	}
	return $out;
}

sub parseline {
	local $_ = shift;
	return unless $_;
	my @sentence;
	until (/\G$/gc) { # until pos at end of string
		if (/\G([A-Za-z']+)/gc) {
			push @sentence, { type => 'word', 'content' => $1 };
		} elsif (/\G([^A-Za-z']+)/gc) {
			push @sentence, { type => 'other', 'content' => $1} ;
		}
	}
	return @sentence;
}

sub suffixword {
	local $_ = shift;
	return unless $_;

	return('lolle') if lc($_) eq 'lol';
	return('butte') if lc($_) eq 'but';

	# some simple skips:	
	my $tmp = lc($_);
	$tmp =~ s/[^a-z]//g;
	return $_ if length($tmp) < 4;
	#foreach my $skip (qw(
	#	bad heh ooh
	#)) {
	#	return $_ if $tmp eq $skip;
	#}
	
	# skip rules:
	foreach my $suf (qw( e ng ing ed es ah l er )) {
		if(/$suf[sS]*$/i) {
			return $_;
		}
	}

	my $out = $_;

	# special cases where a consonant gets doubled
	return('whatte') if ($tmp eq 'what');

	# letters that end words that get doubled
	# i.e. l as in 'lol'->'lolle'
	foreach my $suf (qw( l g m n et p r )) {
		if(/${suf}[sS]*$/i) {
			return double_laste($_);
		} else {
			next;
		}
		return $out;
	}
	
	# letters that end words that just get 'e'
	# i.e. k as in 'fuck'->'fucke'
	foreach my $suf (qw( d k h t )) {
		if(/$suf[sS]*$/i) {
			return single_laste($_);
		} else {
			next;
		}
	}

	# if we got this far, just return the original word unmodified
	return $_;
}

sub single_laste {
	local $_ = shift;
	my $s = '';
	if(/s$/i) { $s = 's'; s/s$//; }
	return($_ . 'e' .$s);
}

sub double_laste {
	local $_ = shift;
	my $s = '';
	if(/s$/i) { $s = 's'; s/s$//; }
	/([a-zA-Z])$/;
	my $last = $1;
	$last = '' if /${last}${last}$/;
	return($_ . $last . 'e' . $s);
}

Irssi::signal_add('send text' => 'send_text');
