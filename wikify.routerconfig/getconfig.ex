#!/usr/bin/expect -f
set hostname [lindex $argv 0]
set timeout 20
spawn scp root@$hostname:running-config ./fetchedconfig
set pass "ROUTER_PASSWORD_HERE"
expect {
        password: {send "$pass\r" ; exp_continue}
    eof exit
}

