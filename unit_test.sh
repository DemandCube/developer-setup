#!/bin/sh
expect -c 'set timeout 6000
spawn bash /home/developersetup/setup.sh
puts \"Developer Setup Started\"
expect \"\[Y/n]\" { send \"y\r\" exp_continue}
#expect "INSTALLED" {
#        if { $expect_out(0,string) == "INSTALLED" } {
#                puts "$expect_out(buffer) PASS";
#        } else  {
#                puts "FAIL";
#        } 
#}
interact'

#/home/developersetup/unit_test.exp
