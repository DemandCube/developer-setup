#!/bin/sh




command -v pip >/dev/null 2>&1
INSTALLED=$?
echo ""

if [ ! $INSTALLED == 0 ] ; then
    echo "FAIL: [ pip ]"
else
    echo "PASS: [ pip ]"
    # pip -V  # pip verions only works on 1.4
fi

command -v ansible >/dev/null 2>&1
INSTALLED=$?
echo ""


if [ ! $INSTALLED == 0 ] ; then
    echo "FAIL: [ ansible ]"
else
    VERSION=`ansible --version | awk '{ print $2 }'`
    echo "PASS: [ ansible $VERSION]"
fi

command -v nosetests >/dev/null 2>&1
INSTALLED=$?
echo ""
if [ $INSTALLED == 0 ] ; then
    VERSION=`nosetests --version | cut -f3 -d" "`
    echo "PASS: [ nose $VERSION]"
    
else
    echo "FAIL: [ nose ]"
fi

command -v virtualbox >/dev/null 2>&1
INSTALLED=$?

if [ $INSTALLED == 0 ] ; then
    echo "[INFO]: VirtualBox is already installed."
    echo ""
    # first command outputs full version(eg. 4.2.6r02546) and second command removes release part of version(eg. r025) 
    VERSION=`VBoxManage -v | cut -f1 -d"r"`
    echo "PASS: [ Virtualbox $VERSION]"
else
    echo "FAIL: [ Virtualbox ]"
fi

command -v vagrant >/dev/null 2>&1
INSTALLED=$?
 
# Test if already installed
if [ $INSTALLED == 0 ] ; then
    VERSION_VAGRANT=`vagrant -v | awk '{ print $2 }'`                
    echo "PASS: [ Vagrant $VERSION]"
else
    echo "FAIL: [ Vagrant ]"
fi 

command -v java -version >/dev/null 2>&1
INSTALLED=$?
echo ""


if [ $INSTALLED == 0 ] ; then
    VERSION_JAVA=`java -version 2>&1 | awk '{ print $3 }' | head -n 1 | tr -d '"'`
    VERSION_JAVA=${VERSION_JAVA%%_*}
    echo "PASS: [ Java $VERSION_JAVA]"
else
    echo "FAIL: [ Java ]"
fi

command -v git --version >/dev/null 2>&1
INSTALLED=$?
echo ""

if [ $INSTALLED == 0 ] ; then
    VERSION=`git --version | awk '{print $3}'`
    echo "PASS: [Git $VERSION]"
else
    # Git is not installed
    
     echo "FAIL: [Git]"
fi

#/home/developersetup/unit_test.exp
