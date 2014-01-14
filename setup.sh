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

BASE_DIR=$(cd $(dirname $0);  pwd -P)

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
    VERSION_VIRTUALBOX=$BASE_DIR/bootstrap/mac_app_version.sh org.virtualbox.app.VirtualBox

    $BASE_DIR/bootstrap/version_compare.py $VERSION_VIRTUALBOX $REQUIRED_VIRTUALBOX_VERSION
    CMP_RESULT=$?
    if [ ! $CMP_RESULT -eq 2 ] ; then
        # Remove VIRTUALBOX if not verion: $REQUIRED_VIRTUALBOX_VERSION
        
        # http://stackoverflow.com/questions/226703/how-do-i-prompt-for-input-in-a-linux-shell-script
        echo "Upgrade VirtualBox (Delete and Install)?"
        while true; do
            read -p "Is this ok [y/N]:" yn
            case $yn in
                [Yy]* ) make install; break;;
                [Nn]* ) exit;;
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
    :
fi



