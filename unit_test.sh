#!/bin/sh


command -v git --version >/dev/null 2>&1
INSTALLED=$?
echo ""

if [ $INSTALLED == 0 ] ; then
    VERSION_GIT=`git --version | awk '{print $3}'`
    echo "PASS: [Git $VERSION_GIT]"
else
    # Git is not installed
    
     echo "FAIL: [Git]"
fi


PIP_VERSION=1.5.4
command -v pip >/dev/null 2>&1
INSTALLED=$?
echo ""

if [ ! $INSTALLED == 0 ] ; then
    echo "FAIL: [pip]"
else
    echo "PASS: [ pip ]"
    # pip -V  # pip verions only works on 1.4
fi


#/home/developersetup/unit_test.exp
