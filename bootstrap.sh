#!/bin/sh


# Test if easy_install exists
# If it doesn't install it

# curl -O http://python-distribute.org/distribute_setup.py
# sudo python distribute_setup.py
# sudo rm distribute_setup.py

# TEST if not existent command
# command -v foo >/dev/null 2>&1
# INSTALLED=$?
# echo $INSTALLED # -> 1
# 
# TEST for command that exists
# command -v java >/dev/null 2>&1
# INSTALLED=$?
# echo $INSTALLED # -> 0


# Test if python is installed
command -v python >/dev/null 2>&1
INSTALLED=$?

if [ ! $INSTALLED == 0 ] ; then
	echo "Install python it's missing"
	exit 1
fi

# Test if python version is 2.6 or above
# python 2.7.5
python -c 'import sys; version=sys.version_info[0]*10; version=version+sys.version_info[1];sys.exit(1)if(version<26) else sys.exit(0)'
INSTALLED=$?
echo ""

if [ ! $INSTALLED == 0 ] ; then
	echo "Install python greater than 2.5"
	exit 1
else
	echo "INSTALLED: [ python ]"
	printf "\t"
	python -V
fi

# Test if easy_install if not install manually
command -v easy_install >/dev/null 2>&1
INSTALLED=$?
echo ""

if [ ! $INSTALLED == 0 ] ; then
	echo "Install easy_install it's missing"
	echo curl -O http://python-distribute.org/distribute_setup.py
	echo sudo python distribute_setup.py
	echo sudo rm distribute_setup.py
	exit 1
else
	echo "INSTALLED: [ easy_install ]"
fi


# Test and install pip if not installed
# pip 1.4.1
command -v pip >/dev/null 2>&1
INSTALLED=$?
echo ""

if [ ! $INSTALLED == 0 ] ; then
	echo "INSTALLING: [ pip ]"
	printf "\t"
	sudo easy_install pip
else
	echo "INSTALLED: [ pip ]"
	printf "\t"
	pip -V
fi


# installed ansible paramiko jinja2 PyYAML httplib2 pycrypto ecdsa markupsafe
# install libselinux-python on remote nodes using selinux

# Test and install ansible if not installed
# ansible 1.4.3
	# paramiko-1.12.0
	# Jinja2-2.7.1
	# PyYAML-3.10
	# httplib2-0.8
	# pycrypto-2.6.1
	# ecdsa-0.10
	# MarkupSafe-0.18



command -v ansible >/dev/null 2>&1
INSTALLED=$?
echo ""

if [ ! $INSTALLED == 0 ] ; then
	echo "INSTALLING: [ ansible ]"
	printf "\t"
	sudo pip install ansible
else
	echo "INSTALLED: [ ansible ]"
	printf "\t"
	ansible --version
fi
