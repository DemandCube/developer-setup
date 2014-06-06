#!/bin/sh
exit 1;
BASE_DIR=$(cd $(dirname $0);  pwd -P)
#sudo ln -sf bash /bin/sh
source $BASE_DIR/bootstrap/os_meta_info.sh

#./bootstrap/os_meta_info.sh
#if [ $OS_DISTRO == "CentOS" ] ; then
#    sudo yum update
#   sudo yum -y install expect
#elif [ $OS_DISTRO == "Ubuntu" ] ; then
#    sudo apt-get update
#    sudo apt-get install -y expect
#fi

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
    EXIT_VALUE=0;
fi

command -v ansible >/dev/null 2>&1
INSTALLED=$?
if [ ! $INSTALLED == 0 ] ; then
    echo "FAIL: [ ansible ]"
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
fi

command -v virtualbox >/dev/null 2>&1
INSTALLED=$?
if [ $INSTALLED == 0 ] ; then
    VERSION=`VBoxManage -v | cut -f1 -d"r"`
    echo "PASS: [ Virtualbox $VERSION]"
else
    echo "FAIL: [ Virtualbox ]"
fi

command -v vagrant >/dev/null 2>&1
INSTALLED=$?

if [ $INSTALLED == 0 ] ; then
    VERSION=`vagrant -v | awk '{ print $2 }'`                
    echo "PASS: [ Vagrant $VERSION]"
else
    echo "FAIL: [ Vagrant ]"
fi 

command -v java -version >/dev/null 2>&1
INSTALLED=$?
if [ $INSTALLED == 0 ] ; then
    VERSION=`java -version 2>&1 | awk '{ print $3 }' | head -n 1 | tr -d '"'`
    VERSION=${VERSION_JAVA%%_*}
    echo "PASS: [ Java $VERSION]"
else
    echo "FAIL: [ Java ]"
fi

command -v git --version >/dev/null 2>&1
INSTALLED=$?
if [ $INSTALLED == 0 ] ; then
    VERSION=`git --version | awk '{print $3}'`
    echo "PASS: [ Git $VERSION ]"
else
    echo "FAIL: [ Git ]"
fi

echo "*************************************************************************************************************"
