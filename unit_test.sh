#!/bin/sh
expect -c 'set timeout 6000
spawn bash /home/developersetup/setup.sh
puts "Developer Setup Started"
expect "\[y|Y/n|N]" { 
  send "y\r";
  exp_continue;
}
#expect "INSTALLED" {
#        if { $expect_out(0,string) == "INSTALLED" } {
#                puts "$expect_out(buffer) PASS";
#        } else  {
#                puts "FAIL";
#        } 
#}'

command -v git --version >/dev/null 2>&1
INSTALLED=$?
echo ""

if [ $INSTALLED == 0 ] ; then
    #  Git is installed
    # git version 1.7.4.4
    VERSION_GIT=`git --version | awk '{print $3}'`
    
    echo "PASS: [Git $VERSION_GIT]"
    #printf "\t"
    #echo "$VERSION_GIT"

else
    # Git is not installed
    #INSTALL_GIT=1
     echo "FAIL: [Git]"
fi

#/home/developersetup/unit_test.exp
