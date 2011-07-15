#!/usr/bin/perl
# 03 April 2008 (header added in 2011)
# pub   4096R/DF2A55C2 2010-10-21
#       Key fingerprint = 5539 AD00 DE4C 42F3 AFE1  1575 0524 43F4 DF2A 55C2
# uid                  Jeffrey Paul <sneak@datavibe.net>

use strict;
use warnings qw( all );
use LWP::UserAgent;
use WWW::Mechanize;
use Data::Dumper;
use Mail::Internet;
use MIME::Base64;

my $debug = 1;
my $gcuser = 'grandcentral_user';
my $gcpass = 'grandcentral_pass';

# this works as of 20080403:
my $uastring = 'BlackBerry8320/4.2.2 Profile/MIDP-2.0 '.
        'Configuration/CLDC-1.1 VendorID/100';
my $savedir = '/home/jpaulvoicemail/vm';
my $mech;

main();

sub main {
    my $msg = loadmsg();
    my ($url,$mhash) = parse_email($msg);
    die("unable to fetch voicemail") unless $mhash;
    my $mp3data = fetch_vm($url);
    die("unable to fetch voicemail") unless $mp3data;
    my $h = fetch_voicemail_meta();
    die("unable to get metadata for this voicemail") unless $h->{$mhash};
    print Data::Dumper::Dumper($h->{$mhash});
    my $fn =    $h->{$mhash}{'timestamp'} . "_" .
            $h->{$mhash}{'from'} . "_" .
            $mhash . ".mp3";
    writefile($savedir . "/" . $fn, $mp3data);
}

sub parse_email {
    my $raw = shift;
    $raw =~ s/\s+/ /g;
    die unless $raw =~ /forwarded_messages\/\?unique_key\=([0-9a-f]+)\&mhash\=([0-9a-f]+)/;
    my $url =
        "http://www.grandcentral.com/".
        "forwarded_messages/?unique_key=$1&mhash=$2";
    return $url,$2;
}

sub fetch_vm {
    my $url = shift;
    my $ua = LWP::UserAgent->new(
        agent => $uastring,
        cookie_jar => { }
    );
    $ua->env_proxy;
    $ua->timeout(10);
    my $r = $ua->get($url);
    return unless $r->is_success;
    die("wtf google") unless $r->content_type eq 'audio/mpeg';
    return $r->content;
}

sub dout {
    return unless defined($debug) && $debug;
    my $msg = shift;
    chomp $msg;
    print STDOUT "*** $0: " . $msg . "\n";
}

sub writefile {
    my $fn = shift;
    my $content = shift;
    open(OUT,">$fn") or die("Can't open $fn for writing: $!");
    print OUT $content;
    close(OUT);
    dout("wrote $fn");
}

sub fetch_voicemail_meta {
    my $url = 'http://grandcentral.com/mobile';
    $mech = WWW::Mechanize->new( agent => $uastring);
    $mech->get( $url );
    die("unable to fetch vm list") unless $mech->success();
    $mech->submit_form(
               form_number => 1,
               fields    => {
                username => $gcuser,
            password => $gcpass,
        },
           );
    die("unable to fetch vm list") unless $mech->success();
    $mech->submit_form(
        form_number => 1,
        fields  => {
            default_number => 'custom',
            custom_number => '3131111111', #detroit uber alles
        },
    );
    die("unable to fetch vm list") unless $mech->success();
    $mech->follow_link( text => 'Inbox' );
    die("unable to fetch vm list") unless $mech->success();
    my @blocks = parse_page_into_vm_blocks($mech->content());
    return(lr2hr(\@blocks,'mhash'));
}

sub parse_page_into_vm_blocks {
    my $in = shift;
    $in =~ s/\n/ /g;
    $in =~ s/\r/ /g;
    $in =~ s/\s+/ /g;
    die unless $in =~ /<table width="100%" cellspacing="0" cellpadding="0">(.*)<\/table>/;
    my $tablecontent = $1;
    my @rows = split(/\s*<\/tr>\s*/,$tablecontent);
    my @parsed;
    foreach my $row (@rows) {
        next unless $row =~ /send_voicemail/;
        push(@parsed,parse_vm_block($row));
    }
    return(@parsed);
}

sub parse_vm_block {
    my $block = shift;
    my $out;
    die unless $block =~ /files\/send_voicemail\/([a-z0-9]+)/;
    $out->{'mhash'} = $1;
    
    die unless $block =~ / ([0-9][0-9])\:([0-9][0-9]) ([AP]M)/;
    my $hh = $1;
    my $mm = $2;
    my $ap = $3;
    
    $hh = '00' if ( $ap eq 'AM' && $hh eq '12');
    $ap = 'AM' if ( $ap eq 'PM' && $hh eq '12'); #stupid 12h time

    $out->{'timestamp'} = $hh . $mm;
    $out->{'timestamp'} += 1200 if $ap eq 'PM'; #convert to 24h
    
    die unless $block =~ /([0-9][0-9])\/([0-9][0-9])\/([0-9][0-9][0-9][0-9]) <br\/>/;
    $out->{'timestamp'} = $3 . $1 . $2 . $out->{'timestamp'};

    $out->{'from'} = '0000000000';
    $out->{'from'} = $1 if $block =~ /destno=([0-9]+)/;
    
    return $out;
}

sub lr2hr {
    my $lr = shift;
    my $key = shift;
    my $r;
    foreach my $item (@{$lr}) {
        next unless $item->{$key};
        $r->{$item->{$key}} = $item;
    }
    return $r;
}

sub loadmsg {
    my $raw = readinput();
    my @lines = split(/\n/,$raw);
    shift(@lines)
        until($lines[0] =~ /^Content-Transfer-Encoding\:\ base64/);
    shift(@lines);
    shift(@lines);
    $raw = join("\n",@lines);
    die unless $raw;
    $raw = MIME::Base64::decode_base64($raw);
    die unless $raw;
    return $raw;
}

sub readinput {
    my $in;
    read(STDIN,$in,1024*10); # 10kB sufficient
    close(STDIN);
    return $in;
}

1;

__END__
