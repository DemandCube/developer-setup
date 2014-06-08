#!/bin/sh

expect -c 'set timeout 6000
spawn bash /home/developersetup/setup.sh
puts "Developer Setup Started"
expect "\[y|Y/n|N]" { 
  send "y\r";
  exp_continue;
}'

echo ""
echo ""
echo ""
echo ""
echo ""
echo "*************************************************************************************************************"
echo "                                      Developer-Setup Unit Test Results                                     "
echo "*************************************************************************************************************"

EXIT_VALUE=0;
command -v pip >/dev/null 2>&1
INSTALLED=$?
if [ ! $INSTALLED == 0 ] ; then
    echo "FAIL: [ pip ]"
    EXIT_VALUE=1;
else
    echo "PASS: [ pip ]"
fi

command -v ansible >/dev/null 2>&1
INSTALLED=$?
if [ ! $INSTALLED == 0 ] ; then
    echo "FAIL: [ ansible ]"
    EXIT_VALUE=1;
else
    VERSION=`ansible --version | awk '{ print $2 }'`
    echo "PASS: [ ansible $VERSION]"
fi

command -v nosetests >/dev/null 2>&1
INSTALLED=$?
if [ $INSTALLED == 0 ] ; then
    VERSION=`nosetests --version | cut -f3 -d" "`
    echo "PASS: [ nose $VERSION]"
else
    echo "FAIL: [ nose ]"
    EXIT_VALUE=1;
fi

command -v virtualbox >/dev/null 2>&1
INSTALLED=$?
if [ $INSTALLED == 0 ] ; then
    VERSION=`VBoxManage -v | cut -f1 -d"r"`
    echo "PASS: [ Virtualbox $VERSION]"
else
    echo "FAIL: [ Virtualbox ]"
    EXIT_VALUE=1;
fi

command -v vagrant >/dev/null 2>&1
INSTALLED=$?

if [ $INSTALLED == 0 ] ; then
    VERSION=`vagrant -v | awk '{ print $2 }'`                
    echo "PASS: [ Vagrant $VERSION]"
else
    echo "FAIL: [ Vagrant ]"
    EXIT_VALUE=1;
fi 

command -v java -version >/dev/null 2>&1
INSTALLED=$?
if [ $INSTALLED == 0 ] ; then
    VERSION=`java -version 2>&1 | awk '{ print $3 }' | head -n 1 | tr -d '"'`
    VERSION=${VERSION_JAVA%%_*}
    echo "PASS: [ Java $VERSION]"
else
    echo "FAIL: [ Java ]"
    EXIT_VALUE=1;
fi



command -v git --version >/dev/null 2>&1
INSTALLED=$?
if [ $INSTALLED == 0 ] ; then
    VERSION=`git --version | awk '{print $3}'`
    echo "PASS: [ Git $VERSION ]"
else
    echo "FAIL: [ Git ]"
    EXIT_VALUE=1;
fi
echo "*************************************************************************************************************"
exit $EXIT_VALUE;
