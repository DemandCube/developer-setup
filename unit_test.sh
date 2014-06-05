#!/bin/sh
chmod 777 /home/developersetup/unit_test.exp
chmod +x /home/developersetup/bootstrap/os_meta_info.sh

expect -c 'set timeout 6000
spawn bash /home/developersetup/setup.sh
puts "Developer Setup Started"
#expect "\[Y/n]" { send "y\r" }

expect "INSTALLED" {
        if { $expect_out(0,string) == "INSTALLED" } {
                puts "$expect_out(buffer) PASS";
        } else  {
                puts "FAIL";
        } 
}
#expect "Deployment successfully completed..." {send "\r"}
interact'

#/home/developersetup/unit_test.exp
