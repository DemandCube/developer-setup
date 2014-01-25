#!/bin/sh

# -*- coding: utf-8 -*-
# (c) 2013, Steve Morin <steve@stevemorin.com>
#
# This file is part of the DemandCube, (the "Project")
#
# This Project is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This Project is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this Project.  If not, see <http://www.gnu.org/licenses/agpl-3.0.html>.


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

BASE_DIR=$(cd $(dirname $0);  pwd -P)
source $BASE_DIR/bootstrap/os_meta_info.sh


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
	echo "Install python greater than 2.6"
	exit 1
else
	echo "INSTALLED: [ python ]"
	printf "\t"
	python -V 2>&1 | awk '{ print $2 }'
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
PIP_VERSION=1.5
INSTALLED=$?
echo ""

if [ ! $INSTALLED == 0 ] ; then
	echo "INSTALLING: [ pip ]"
	printf "\t"
	sudo easy_install pip
else
	echo "INSTALLED: [ pip ]"
	printf "\t"
	$BASE_DIR/bootstrap/version_compare.py `$BASE_DIR/bootstrap/pip_version.py` $PIP_VERSION
	CMP_RESULT=$?
	if [ $CMP_RESULT -lt 2 ] ; then
	    # Upgrade pip
	    $BASE_DIR/bootstrap/pip_version.py
	    echo "Upgrading pip to $PIP_VERSION"
	    # http://www.pip-installer.org/en/latest/installing.html#install-or-upgrade-pip
	    sudo pip install --upgrade setuptools
	    SETUPTOOLS_RESULT=$?
	    if [ $SETUPTOOLS_RESULT -ne 0 ] ; then
	        echo "upgrading setuptools failed try manually"
	        exit 1
        fi
	    curl https://raw.github.com/pypa/pip/master/contrib/get-pip.py -O
	    CURL_RESULT=$?
	    if [ $CURL_RESULT -ne 0 ] ; then
	        echo "downloading new pip failed try manually"
	        exit 1
        fi
	    sudo python get-pip.py
	    PIP_RESULT=$?
	    echo "PIP_RESULT:$PIP_RESULT"
	    if [ $PIP_RESULT -ne 0 ] ; then
	        echo "upgrading pip failed try manually"
	        exit 1
        fi
	    rm get-pip.py
	    echo "New Pip Version"
	    $BASE_DIR/bootstrap/pip_version.py
	    # https://pypi.python.org/pypi/setuptools#installation-instructions
	    # Instructions to Install setuptools
	    # 
        # curl https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py -O
        # sudo python ez_setup.py
        # rm ez_setup.py
	elif [ $CMP_RESULT -eq 0 ] ; then
	    echo "There was an error comparing the pip version, please check manually"
	    exit 1
	else
	    $BASE_DIR/bootstrap/pip_version.py
    fi
	# pip -V  # pip verions only works on 1.4
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

# Todo test for version and upgrade

# Version 1.4.4

if [ ! $INSTALLED == 0 ] ; then
	echo "INSTALLING: [ ansible ]"
	printf "\t"
	sudo pip install paramiko PyYAML jinja2 httplib2
	sudo pip install ansible
else
	echo "INSTALLED: [ ansible ]"
	printf "\t"
	ansible --version | awk '{ print $2 }'
fi

#Determining OS and taking action accordingly
case $OS_NAME in
	"linux" )
			echo -e "$OS_NAME is current OS. \n"
            case $OS_DISTRO in
             	"CentOS" )
                        echo -e "$OS_DISTRO flavour of $OS_NAME found.\n"
                        sh centos64-setup.sh
                        break
             	        ;;
                * )     
						#Cases for other Distros such as Debian,Ubuntu,SuSe,Solaris etc may come here 
                        echo -e "Script to install is not available for $OS_NAME. \n Please install manually."
						break
						;;
            esac
            break
             ;;
    "Darwin" ) 
		# $BASE_DIR/bootstrap/mac_app_installed.sh
		# $BASE_DIR/bootstrap/mac_app_version.sh
		# org.virtualbox.app.VirtualBox

		$BASE_DIR/bootstrap/mac_app_installed.sh org.virtualbox.app.VirtualBox
		INSTALLED=$?
		echo ""

		INSTALL_VIRTUALBOX=''
		REQUIRED_VIRTUALBOX_VERSION=4.2.16
		REQUIRED_VAGRANT_VERSION=1.3.5

		# https://github.com/noitcudni/vagrant-ae

		if [ $INSTALLED == 1 ] ; then
		    #  VirtualBox is installed
		    VERSION_VIRTUALBOX=`$BASE_DIR/bootstrap/mac_app_version.sh org.virtualbox.app.VirtualBox`
	
			echo "INSTALLED: [ VirtualBox ]"
			printf "\t"
			echo "$VERSION_VIRTUALBOX"

		    $BASE_DIR/bootstrap/version_compare.py $VERSION_VIRTUALBOX $REQUIRED_VIRTUALBOX_VERSION
		    CMP_RESULT=$?
		    if [ ! $CMP_RESULT -eq 2 ] ; then
		        # Remove VIRTUALBOX if not verion: $REQUIRED_VIRTUALBOX_VERSION
		        # http://stackoverflow.com/questions/226703/how-do-i-prompt-for-input-in-a-linux-shell-script
				
				echo "Current VirtualBox Version: $VERSION_VIRTUALBOX"
				echo "Required VirtualBox Version: $REQUIRED_VIRTUALBOX_VERSION"
				echo ""
				
		        echo "Install Correct VirtualBox (Delete and Install)?"
		        while true; do
		            read -p "Is this ok [y/N]:" yn
		            case $yn in
		                [Yy]* ) 
							echo "Removing VirtualBox";
							PATH_VIRTUALBOX=`$BASE_DIR/bootstrap/mac_app_path.sh org.virtualbox.app.VirtualBox`
							if [ ! $? -eq 0 ] ; then
								echo "Determining Path to VirtualBox returned and error."
								echo "Please manually remove VirtualBox"
								exit 1;
							fi
							
					        echo "Remove Path ($PATH_VIRTUALBOX):?"
					        while true; do
					            read -p "Is this ok [y/N]:" yn
					            case $yn in
					                [Yy]* ) 
										echo "Removing VirtualBox";
										INSTALL_VIRTUALBOX=1
										if [ -n "$PATH_VIRTUALBOX" -a -d "$PATH_VIRTUALBOX" ] ; then
											sudo rm -rf $PATH_VIRTUALBOX
										fi
										break;;
					                [Nn]* ) echo "Skipping Removing"; break;;
					                * ) echo "Please answer yes or no.";;
					            esac
					        done
							
							break;;
		                [Nn]* ) echo "No"; break;;
		                * ) echo "Please answer yes or no.";;
		            esac
		        done
				
		    fi
		else
		    # VirtualBox is not installed
		    INSTALL_VIRTUALBOX=1
		    echo "Not Installed"
		fi

		# Install VirtualBox
		if [ -n "$INSTALL_VIRTUALBOX" ] ; then
		    echo "Install VirtualBox"
		    VIRTUALBOX_FILE="$HOME/Downloads/VirtualBox-$REQUIRED_VIRTUALBOX_VERSION.dmg"
		    if [ ! -d "$VIRTUALBOX_FILE" ] ; then
		        # Find version here
		        # http://download.virtualbox.org/virtualbox/
		        curl -Lk http://download.virtualbox.org/virtualbox/4.2.16/VirtualBox-4.2.16-86992-OSX.dmg -o $VIRTUALBOX_FILE
		    fi
		    hdiutil attach $VIRTUALBOX_FILE
		    sudo installer -package /Volumes/VirtualBox/VirtualBox.pkg -target '/Volumes/Macintosh HD'
		    hdiutil detach /Volumes/VirtualBox/
		    
		    rm $VIRTUALBOX_FILE
		fi



		command -v vagrant >/dev/null 2>&1
		INSTALLED=$?
		echo ""

		INSTALL_VAGRANT=''
		REQUIRED_VAGRANT_VERSION=1.4.3

		# https://github.com/noitcudni/vagrant-ae

		if [ $INSTALLED == 0 ] ; then
		    #  Vagrant is installed
		    VERSION_VAGRANT=`vagrant -v | awk '{ print $2 }'`

			echo "INSTALLED: [ Vagrant ]"
			printf "\t"
			echo "$VERSION_VAGRANT"

		    $BASE_DIR/bootstrap/version_compare.py $VERSION_VAGRANT $REQUIRED_VAGRANT_VERSION
		    CMP_RESULT=$?
		    if [ ! $CMP_RESULT -eq 2 ] ; then
		        # Remove VAGRANT if not verion: $REQUIRED_VAGRANT_VERSION
		        # http://stackoverflow.com/questions/226703/how-do-i-prompt-for-input-in-a-linux-shell-script
				
				echo "Current Vagrant Version: $VERSION_VAGRANT"
				echo "Required Vagrant Version: $REQUIRED_VAGRANT_VERSION"
				echo ""
				
		        echo "Install Correct Vagrant (Delete and Install)?"
		        while true; do
		            read -p "Is this ok [y/N]:" yn
		            case $yn in
		                [Yy]* ) 
							echo "Removing Vagrant";
							
							# For Mac OS X
		                    sudo rm -rf /Applications/Vagrant
		                    sudo rm /usr/bin/vagrant
		                    
		                    # For Linux
		                    # sudo rm -rf /opt/vagrant
		                    # sudo rm /usr/bin/vagrant
		                    
		                    # User Dir
		                    # ~/.vagrant.d
		                    INSTALL_VAGRANT=1
							break;;
		                [Nn]* ) echo "No"; break;;
		                * ) echo "Please answer yes or no.";;
		            esac
		        done
				
		    fi
		else
		    # Vagrant is not installed
		    INSTALL_VAGRANT=1
		    echo "Not Installed"
		fi

		# Install Vagrant
		if [ -n "$INSTALL_VAGRANT" ] ; then
		    echo "Install Vagrant"
		    VAGRANT_FILE="$HOME/Downloads/Vagrant-$REQUIRED_VAGRANT_VERSION.dmg"
		    if [ ! -d "$VAGRANT_FILE" ] ; then
		        # Find version here
		        # http://download.virtualbox.org/virtualbox/
		        curl -Lk https://dl.bintray.com/mitchellh/vagrant/Vagrant-1.4.3.dmg -o $VAGRANT_FILE
		    fi
		    hdiutil attach $VAGRANT_FILE
		    sudo installer -package /Volumes/Vagrant/Vagrant.pkg -target '/Volumes/Macintosh HD'
		    hdiutil detach /Volumes/Vagrant/
		    
		    rm $VAGRANT_FILE
		fi
           break
           ;;
    * )
      #Cases for other OS such as windows etc may come here 
      echo -e "Script to install is not available for $OS_NAME. \n Please install manually."
      break
      ;;             
esac