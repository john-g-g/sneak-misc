#!/usr/bin/perl
# This is PGoatP, for goatseing pgp keys
# 2011 sneak@datavibe.net
# sorry to everyone forever for pissing in the collective pool
# apologies to dfw for the name
# and thanks to MIT for using monospaced fonts on the web

use strict;
use warnings qw( all );

our $keyserver = 'pgp.mit.edu';
our $tmpdir = '/tmp/pgoat.' . $$;  # run only in single user mode, dumbass.
our $gpg_opts = qq{--batch --homedir '$tmpdir'};

main();

sub main {
    if (@ARGV < 1) {
        die "usage: $0 <target keyid> [ascii file]\n";
    }

    pgoatp({
        keyserver => $keyserver,
        target => $ARGV[0],
        ascii => [ split(/\n/,(@ARGV == 1) ? goatse() : readfile($ARGV[1])) ],
    });

}

sub pgoatp {
    my $opts = shift;
    unlink($tmpdir);  # woo temp file race
    mkdir($tmpdir) unless -d $tmpdir;
    chmod 0700, $tmpdir;
    my $target = $opts->{'target'};
    print "fetching target key...\n";
    `gpg $gpg_opts -q --keyserver $keyserver --recv-key $target`;
    my $x = 0;
    my @trollkeys;
    foreach my $line (@{$opts->{'ascii'}}) {
        next if $line =~ /^\s*$/;
        printf(
            "%i%% done generating keys\n",
            ($x/@{$opts->{'ascii'}})*100
        );
        my $keyid = gen_key({
                name => $line
        });
        push(@trollkeys,$keyid);
        `gpg -q $gpg_opts --yes --default-key $keyid --sign-key $target 2>&1`;
        $x++;
    }

    print "preview:\n";
    print `gpg $gpg_opts --list-sigs $target`;

    print "\n\n*** you have ten seconds to control-c to cancel! *** \n\n";
    sleep 10;
    print `gpg $gpg_opts --keyserver $keyserver --send-key $target`;
    foreach my $keyid (@trollkeys) {
        print `gpg $gpg_opts --keyserver $keyserver --send-key $keyid`;
    }
}

sub gen_key {
    my $opts = shift;
    open(FH,'>' . $tmpdir . '/input') or die;
    my $format = 
q{Key-Type: DSA
Key-Length: 1024
Subkey-Type: ELG-E
Subkey-Length: 1024
Name-Real: %s
Expire-Date: 0
%%pubring %s/pub
%%secring %s/sec
%%commit
};

    printf FH $format,$opts->{'name'},$tmpdir,$tmpdir;
    `gpg $gpg_opts --gen-key $tmpdir/input 2>&1 `;
    my $out = `gpg $gpg_opts --import $tmpdir/sec $tmpdir/pub 2>&1 `;
    unlink($tmpdir . '/sec');
    unlink($tmpdir . '/pub');
    #print $out; die;
    die unless $out =~ /key (\S+?)\:/m;
    return $1;
}

sub readfile {
    my $fn = shift;
    open(FH,$fn) or die "can't open file $fn for reading: $!\n";
    my $data;
    read(FH,$data,1024*5);  # 5kb ought to be enough for anyone
    close(FH);
    return $data;
}

sub goatse { q{
* g o a t s e x * g o a t s e x * g o a t s e x *
g                                               g
o /     \             \            /    \       o
a|       |             \          |      |      a
t|       `.             |         |       :     t
s`        |             |        \|       |     s
e \       | /       /  \\\\\   --__ \\\\      :     e
x  \      \/   _--~~          ~--__| \     |    x
*   \      \_-~                    ~-_\    |    *
g    \_     \        _.--------.______\|   |    g
o      \     \______// _ ___ _ (_(__>  \   |    o
a       \   .  C ___)  ______ (_(____>  |  /    a
t       /\ |   C ____)/      \ (_____>  |_/     t
s      / /\|   C_____)       |  (___>   /  \    s
e     |   (   _C_____)\______/  // _/ /     \   e
x     |    \  |__   \\\\_________// (__/       |  x
*    | \    \____)   `----   --'             |  *
g    |  \_          ___\       /_          _/ | g
o   |              /    |     |  \            | o
a   |             |    /       \  \           | a
t   |          / /    |         |  \           |t
s   |         / /      \__/\___/    |          |s
e  |           /        |    |       |         |e
x  |          |         |    |       |         |x
* g o a t s e x * g o a t s e x * g o a t s e x *
};
}

1;

__END__
