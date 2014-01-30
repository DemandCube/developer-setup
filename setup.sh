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

echo "                                                  ";
echo ",--.                         |,---.     |         ";
echo "|   |,---.,-.-.,---.,---.,---||    .   .|---.,---.";
echo "|   ||---'| | |,---||   ||   ||    |   ||   ||---'";
echo "\`--' \`---'\` ' '\`---^\`   '\`---'\`---'\`---'\`---'\`---'";
echo "                                                  ";

echo "                                                                           ";
echo ",--.                 |                            ,---.     |              ";
echo "|   |,---..    ,,---.|    ,---.,---.,---.,---.    \`---.,---.|--- .   .,---.";
echo "|   ||---' \  / |---'|    |   ||   ||---'|            ||---'|    |   ||   |";
echo "\`--' \`---'  \`'  \`---'\`---'\`---'|---'\`---'\`        \`---'\`---'\`---'\`---'|---'";
echo "                               |                                      |    ";



BASE_DIR=$(cd $(dirname $0);  pwd -P)
#sudo ln -sf bash /bin/sh should be done for Ubuntu in case if source didn't work
source $BASE_DIR/bootstrap/os_meta_info.sh

#######################################
#######################################
###
### Installation of python,easy_install,
### pip,and ansible is same for Ubuntu,
### Mac,and CentOS
###
#######################################
#######################################

########################################
########################################
####    
####   INSTALL PYTHON
####
########################################
########################################

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

########################################
########################################
####    
####   INSTALL EASY_INSTALL
####
########################################
########################################

# Test if easy_install if not install manually
command -v easy_install >/dev/null 2>&1
INSTALLED=$?
echo ""

if [ ! $INSTALLED == 0 ] ; then
    echo "Installing easy_install it was missing"
    curl http://python-distribute.org/distribute_setup.py -o distribute-setup.sh
    sudo python distribute_setup.py
    sudo rm distribute_setup.py
else
    echo "INSTALLED: [ easy_install ]"
fi

########################################
########################################
####    
####   INSTALL PIP
####
########################################
########################################

# Test and install pip if not installed
# pip 1.4.1
PIP_VERSION=1.5
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

########################################
########################################
####    
####   INSTALL ANSIBLE
####
########################################
########################################

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
    
# Test if ansible is already installed
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

########################################
########################################
####    
####   INSTALL VIRTUALBOX
####
########################################
######################################## 

# variable declarations                        
INSTALL_VIRTUALBOX=''
REQUIRED_VIRTUALBOX_VERSION=4.2.16
VERSION_VIRTUALBOX=''
VIRTUALBOX_DOWNLOAD_URL=''
VIRTUALBOX_INSTALL_CMD=''
VIRTUALBOX_FILE=''

#Determining OS and taking action accordingly
case $OS_NAME in
    "linux" )
            echo  "$OS_NAME is current OS. "
            echo  ""
            # Test if VirtualBox is already installed
            command -v virtualbox >/dev/null 2>&1
            INSTALLED=$?

            if [ $INSTALLED == 0 ] ; then
                echo "VirtualBox is already installed."
                echo ""

                VERSION_VIRTUALBOX=`VBoxManage -v`
                VERSION_VIRTUALBOX=${VERSION_VIRTUALBOX:0:6} 

                # Compare the required and found versions 
                $BASE_DIR/bootstrap/version_compare.py $VERSION_VIRTUALBOX $REQUIRED_VIRTUALBOX_VERSION
                CMP_RESULT=$?
                
                # Test if installed version is lower then required version  
                if [ ! $CMP_RESULT -eq 2 ] ; then
                    # Remove VIRTUALBOX if not verion: $REQUIRED_VIRTUALBOX_VERSION      
                    echo "Current VirtualBox Version: $VERSION_VIRTUALBOX"
                    echo "Required VirtualBox Version: $REQUIRED_VIRTUALBOX_VERSION"
                    echo ""                    
                    echo "Install Correct VirtualBox (Delete and Install)?"

                    while true; do
                        read -p "Is this ok [y/N]:" yn
                        case $yn in
                            [Yy]* ) 
                                echo "Removing VirtualBox";
                                INSTALL_VIRTUALBOX=1

                                #Determining OS Distribution and taking remove action accordingly
                                case $OS_DISTRO in
                                    "CentOS" )
                                       echo "$OS_DISTRO - $OS_NAME Proceeding."        
                                       sudo yum remove virtualbox*                  
                                       break;;
                                    "Ubuntu" )
                                       echo "$OS_DISTRO - $OS_NAME Proceeding."
                                       sudo apt-get purge virtualbox*
                                       break;;
                                    * )
                                       #Cases for other Distros such as Debian,Ubuntu,SuSe,Solaris etc may come here 
                                       echo "Script for $OS_NAME "-" $OS_DISTRO has not been tested yet."
                                       echo "Submit Patch to https://github.com/DemandCube/developer-setup."
                                       break;;                                       
                                esac
                                break;;

                            [Nn]* ) 
                                echo "No"; break;;
                            * ) 
                                echo "Please answer yes or no.";;
                        esac
                    done            
                fi                                             
            else
                INSTALL_VIRTUALBOX=1
                echo "VirtualBox is Not Installed"
            fi                        
            # Test whether to install Virtualbox or not
            if [ -n "$INSTALL_VIRTUALBOX" ] ; then
                echo "Install VirtualBox"
                #Determining OS Distribution and taking install action accordingly
                case $OS_DISTRO in
                    "CentOS" )
                       echo "$OS_DISTRO - $OS_NAME Proceeding."        
                       VIRTUALBOX_FILE="$HOME/Downloads/VirtualBox-$REQUIRED_VIRTUALBOX_VERSION.rpm" 
                       VIRTUALBOX_DOWNLOAD_URL="http://download.virtualbox.org/virtualbox/4.2.16/VirtualBox-4.2-4.2.16_86992_el6-1.x86_64.rpm"
                       VIRTUALBOX_INSTALL_CMD="sudo rpm -i"
                       break;;
                    "Ubuntu" )
                       echo "$OS_DISTRO - $OS_NAME Proceeding."
                       VIRTUALBOX_FILE="$HOME/Downloads/VirtualBox-$REQUIRED_VIRTUALBOX_VERSION.deb"
                       VIRTUALBOX_DOWNLOAD_URL="http://download.virtualbox.org/virtualbox/4.2.16/virtualbox-4.2_4.2.16-86992~Ubuntu~precise_amd64.deb"
                       VIRTUALBOX_INSTALL_CMD="sudo dpkg -i"
                       break;;
                    *)
                       #Cases for other Distros such as Debian,Ubuntu,SuSe,Solaris etc may come here 
                       echo "Script for $OS_NAME "-" $OS_DISTRO has not been tested yet."
                       echo "Submit Patch to https://github.com/DemandCube/developer-setup."
                       break;;                                       
                esac
                # Test if Virtualbox needs to be downloaded
                if [ ! -d "$VIRTUALBOX_FILE" ] ; then
                    # Find version here
                    # http://download.virtualbox.org/virtualbox/
                    curl -Lk $VIRTUALBOX_DOWNLOAD_URL -o $VIRTUALBOX_FILE
                fi
                # Installing downloaded file
                $VIRTUALBOX_INSTALL_CMD $VIRTUALBOX_FILE                
                # Removing downloaded file
                rm $VIRTUALBOX_FILE
            fi
            break;;
    "Darwin")
        echo "Mac OS X - Proceeding"

        # $BASE_DIR/bootstrap/mac_app_installed.sh
        # $BASE_DIR/bootstrap/mac_app_version.sh
        # org.virtualbox.app.VirtualBox
        
        # Test virtualbox in system
        $BASE_DIR/bootstrap/mac_app_installed.sh org.virtualbox.app.VirtualBox
        INSTALLED=$?
        echo ""      
        
        # Test if Virtualbox is already installed       
        if [ $INSTALLED == 1 ] ; then
            #  VirtualBox is installed
            VERSION_VIRTUALBOX=`$BASE_DIR/bootstrap/mac_app_version.sh org.virtualbox.app.VirtualBox`

            echo "INSTALLED: [ VirtualBox ]"
            printf "\t"
            echo "$VERSION_VIRTUALBOX"
            
            # Compare the installed and required versions
            $BASE_DIR/bootstrap/version_compare.py $VERSION_VIRTUALBOX $REQUIRED_VIRTUALBOX_VERSION
            CMP_RESULT=$?
            
            # Test if installed version is lower then required version
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
       break;; 

    * )
       #Cases for other Distros such as Debian,Ubuntu,SuSe,Solaris etc may come here 
       echo "Script for $OS_NAME has not been tested yet."
       echo "Submit Patch to https://github.com/DemandCube/developer-setup."
       break;;
esac

########################################
########################################
####    
####   INSTALL VAGRANT
####
########################################
########################################

# variable declarations                        
INSTALL_VAGRANT=''
REQUIRED_VAGRANT_VERSION=1.4.3
VERSION_VAGRANT=''
VAGRANT_DOWNLOAD_URL=''
VAGRANT_INSTALL_CMD=''
VAGRANT_FILE=''

#Determining OS and taking action accordingly
case $OS_NAME in
    "linux" )
            echo  "$OS_NAME is current OS. "
            echo ""
            # Test if Vagrant is installed
            command -v vagrant >/dev/null 2>&1
            INSTALLED=$?

            if [ $INSTALLED == 0 ] ; then
                echo "Vagrant is already installed."  
                echo ""
                VERSION_VAGRANT=`vagrant -v | awk '{ print $2 }'`                
                
                # Comparing installed and required versions
                $BASE_DIR/bootstrap/version_compare.py $VERSION_VAGRANT $REQUIRED_VAGRANT_VERSION
                CMP_RESULT=$?
                
                # Test if installed version is lower then required version
                if [ ! $CMP_RESULT -eq 2 ] ; then
                    # Remove Vagrant if not verion: $REQUIRED_VAGRANT_VERSION      
                    echo "Current Vagrant Version: $VERSION_VAGRANT"
                    echo "Required Vagrant Version: $REQUIRED_VAGRANT_VERSION"
                    echo ""                    
                    echo "Install Correct Vagrant (Delete and Install)?"

                    while true; do
                        read -p "Is this ok [y/N]:" yn
                        case $yn in
                            [Yy]* ) 
                                echo -e "\n Removing Vagrant \n";
                                INSTALL_VAGRANT=1

                                #Determining OS Distribution and taking remove action accordingly
                                case $OS_DISTRO in
                                    "CentOS" )
                                       echo -e "$OS_DISTRO - $OS_NAME Proceeding.\n"        
                                       sudo rm -rf /opt/vagrant
                                       sudo rm /usr/bin/vagrant                 
                                       break;;
                                    "Ubuntu" )
                                       echo -e "$OS_DISTRO - $OS_NAME Proceeding.\n"
                                       sudo rm -rf /opt/vagrant
                                       sudo rm /usr/bin/vagrant
                                       break;;
                                    *)
                                       #Cases for other Distros such as Debian,Ubuntu,SuSe,Solaris etc may come here 
                                       echo "Script for $OS_NAME "-" $OS_DISTRO has not been tested yet."
                                       echo "Submit Patch to https://github.com/DemandCube/developer-setup."
                                       break;;                                       
                                esac
                                break;;

                            [Nn]* ) 
                                echo "No"; break;;
                            * ) 
                                echo "Please answer yes or no.";;
                        esac
                    done            
                fi                                             
            else
                INSTALL_VAGRANT=1
                echo "Vagrant is Not Installed"
            fi   

            # Test whether Vagrant needs to be installed or not
            if [ -n "$INSTALL_VAGRANT" ] ; then
                echo "Install Vagrant"

                #Determining OS Distribution and taking install action accordingly
                case $OS_DISTRO in
                    "CentOS" )
                       echo "$OS_DISTRO - $OS_NAME Proceeding."        
                       VAGRANT_FILE="$HOME/Downloads/Vagrant-$REQUIRED_VAGRANT_VERSION.rpm" 
                       VAGRANT_DOWNLOAD_URL="https://dl.bintray.com/mitchellh/vagrant/vagrant_1.4.3_x86_64.rpm"
                       VAGRANT_INSTALL_CMD='sudo rpm -ivh'
                       break;;
                    "Ubuntu" )
                       echo "$OS_DISTRO - $OS_NAME Proceeding."
                       VAGRANT_FILE="$HOME/Downloads/Vagrant-$REQUIRED_VAGRANT_VERSION.deb"
                       VAGRANT_DOWNLOAD_URL="https://dl.bintray.com/mitchellh/vagrant/vagrant_1.4.3_x86_64.deb"
                       VAGRANT_INSTALL_CMD="sudo dpkg -i"
                       break;;
                    *)
                       #Cases for other Distros such as Debian,Ubuntu,SuSe,Solaris etc may come here 
                       echo "Script for $OS_NAME "-" $OS_DISTRO has not been tested yet."
                       echo "Submit Patch to https://github.com/DemandCube/developer-setup."
                       break;;                                       
                esac

                # Test if Vagrant needs to be downloaded
                if [ ! -d "$VAGRANT_FILE" ] ; then
                    # Find version here
                    # http://download.virtualbox.org/virtualbox/
                    curl -Lk $VAGRANT_DOWNLOAD_URL -o $VAGRANT_FILE
                fi
                # Installing downloaded file
                $VAGRANT_INSTALL_CMD $VAGRANT_FILE               
                # Removing downloaded file
                rm $VAGRANT_FILE
            fi    
            break;;

    "Darwin")
       echo  "$OS_NAME is current OS. "
       echo "" 
       command -v vagrant >/dev/null 2>&1
       INSTALLED=$?
       echo ""

       # https://github.com/noitcudni/vagrant-ae

        if [ $INSTALLED == 0 ] ; then
            #  Vagrant is installed
            VERSION_VAGRANT=`vagrant -v | awk '{ print $2 }'`

            echo "INSTALLED: [ Vagrant ]"
            printf "\t"
            echo "$VERSION_VAGRANT"

            $BASE_DIR/bootstrap/version_compare.py $VERSION_VAGRANT $REQUIRED_VAGRANT_VERSION
            CMP_RESULT=$?

            # Test if install version is exact version
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
       break;; 
    * )
       #Cases for other Distros such as Debian,Ubuntu,SuSe,Solaris etc may come here 
       echo "Script for $OS_NAME has not been tested yet."
       echo "Submit Patch to https://github.com/DemandCube/developer-setup."
       break;;                 
esac    


########################################
########################################
####    
####   INSTALL JAVA
####
########################################
########################################

# Variable declarations
INSTALL_JAVA=''
VERSION_JAVA=''
REQUIRED_JAVA_VERSION=1.7
JAVA_DOWNLOAD_URL=''
JAVA_FILE=''
JAVA_INSTALL_CMD=''

# Testing java installation
command -v java -version >/dev/null 2>&1
INSTALLED=$?
echo ""

# Checking java if installed
if [ $INSTALLED == 0 ] ; then
    #  Java is installed
    
    # java version "1.7.0_17"
    # Java(TM) SE Runtime Environment (build 1.7.0_17-b02)
    # Java HotSpot(TM) 64-Bit Server VM (build 23.7-b01, mixed mode)
    
    # 1) send to standard out
    # 2) pull third column "version"
    # 3) only get first line
    # 4) remove quotes
    
    VERSION_JAVA=`java -version 2>&1 | awk '{ print $3 }' | head -n 1 | tr -d '"'`

    # 1) Remove everything after the "_" underscore
    VERSION_JAVA=${VERSION_JAVA%%_*}
    
    echo "INSTALLED: [ Java ]"
    printf "\t"
    echo "$VERSION_JAVA"

    $BASE_DIR/bootstrap/version_compare.py $VERSION_JAVA $REQUIRED_JAVA_VERSION
    CMP_RESULT=$?
    # Test if installed version is less than required version
    if [ $CMP_RESULT -lt 2 ] ; then
        # Remove JAVA if not verion: $REQUIRED_JAVA_VERSION
        # http://stackoverflow.com/questions/226703/how-do-i-prompt-for-input-in-a-linux-shell-script
    
        echo "Current Java Version: $VERSION_JAVA"
        echo "Required Java Version: $REQUIRED_JAVA_VERSION"
        echo ""
    
        echo "Install Correct Java (Delete and Install)?"
        echo ""
        while true; do
            read -p "Is this ok [y/N]:" yn
            case $yn in
                [Yy]* ) 
                    echo "Skipping Removing Java";
                    echo ""
                
                    # For Mac OS X
                    #Navigate to /Library/Java/JavaVirtualMachines and remove the directory whose name matches the following format:*
                    #    /Library/Java/JavaVirtualMachines/jdk<major>.<minor>.<macro[_update]>.jdk
                    #For example, to uninstall 7u6:
                    #    % rm -rf jdk1.7.0_06.jdk
                
                    # For Linux
                    # sudo rm -rf /opt/vagrant
                    # sudo rm /usr/bin/vagrant
                
                    # User Dir
                    # ~/.vagrant.d
                    INSTALL_JAVA=1
                    break;;
                [Nn]* ) echo "No"; break;;
                * ) echo "Please answer yes or no.";;
            esac
        done
    
    fi
else
    # Java is not installed
    INSTALL_JAVA=1
    echo "Not Installed"
fi
# Install Java
if [ -n "$INSTALL_JAVA" ] ; then
    echo "Install Java"
    
    case $OS_NAME in              
        "linux" )
           echo  "$OS_NAME is current OS"
           echo ""
           case $OS_DISTRO in
               "CentOS" )
                   echo "$OS_DISTRO-$OS_NAME Proceeding..."
                   echo ""
                   JAVA_FILE="$HOME/Downloads/jdk-7u51-linux-x64.rpm"
                   JAVA_DOWNLOAD_URL="http://download.oracle.com/otn-pub/java/jdk/7u51-b13/jdk-7u51-linux-x64.rpm"
                   JAVA_INSTALL_CMD="sudo rpm -i $JAVA_FILE"
                   break ;;
                "Ubuntu" )
                   echo "$OS_DISTRO-$OS_NAME Proceeding..."
                   echo ""
                   JAVA_FILE="$HOME/Downloads/dk-7u51-linux-x64.deb"
                   JAVA_DOWNLOAD_URL="http://download.oracle.com/otn-pub/java/jdk/7u51-b13/jdk-7u51-macosx-x64.deb"
                   JAVA_INSTALL_CMD=''
                   break ;;
                * )
                  break ;;
           esac
           break ;;
        "darwin" )
           echo "Mac OS X Proceeding..."
           echo ""
           JAVA_FILE="$HOME/Downloads/jdk-7u51-macosx-x64.dmg"
           JAVA_DOWNLOAD_URL='http://download.oracle.com/otn-pub/java/jdk/7u51-b13/jdk-7u51-macosx-x64.dmg'
           JAVA_INSTALL_CMD=hdiutil attach $JAVA_FILE; sudo installer -package '/Volumes/JDK 7 Update 51/JDK 7 Update 51.pkg' -target '/Volumes/Macintosh HD'; hdiutil detach '/Volumes/JDK 7 Update 51/'
           break ;;
        * )
           #Cases for other Distros such as Debian,Ubuntu,SuSe,Solaris etc may come here 
           echo "Script for $OS_NAME has not been tested yet."
           echo "Submit Patch to https://github.com/DemandCube/developer-setup."
           break;; 
    esac   
    if [ ! -d "$JAVA_FILE" ] ; then
        # Find version here
        # curl -L --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com;" http://download.oracle.com/otn-pub/java/jdk/7u51-b13/jdk-7u51-macosx-x64.dmg -o jdk-7u51-macosx-x64.dmg
        # http://download.oracle.com/otn-pub/java/jdk/7u51-b13/jdk-7u51-macosx-x64.dmg
        # http://download.oracle.com/otn-pub/java/jdk/7u51-b13/jdk-7u51-linux-x64.rpm  
        echo "Downloading Java..."      
        curl -L --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com;" $JAVA_DOWNLOAD_URL -o $JAVA_FILE
    fi    
    $JAVA_INSTALL_CMD
    rm $JAVA_FILE
fi

########################################
########################################
####    
####   INSTALL GIT
####
########################################
########################################


command -v git --version >/dev/null 2>&1
INSTALLED=$?
echo ""

INSTALL_GIT=''
UNINSTALL_GIT=''
REQUIRED_GIT_VERSION=1.8


if [ $INSTALLED == 0 ] ; then
    #  Git is installed
    
    # git version 1.7.4.4
    
    VERSION_GIT=`git --version | awk '{print $3}'`
    
    echo "INSTALLED: [ Git ]"
    printf "\t"
    echo "$VERSION_GIT"

    $BASE_DIR/bootstrap/version_compare.py $VERSION_GIT $REQUIRED_GIT_VERSION
    CMP_RESULT=$?
    # Test if installed version is less than required version
    if [ $CMP_RESULT -lt 2 ] ; then
        # Remove GIT if not verion: $REQUIRED_GIT_VERSION
        # http://stackoverflow.com/questions/226703/how-do-i-prompt-for-input-in-a-linux-shell-script
    
        echo "Current Git Version: $VERSION_GIT"
        echo "Required Git Version: $REQUIRED_GIT_VERSION"
        echo ""
    
        echo "Install Correct Git (Delete and Install)?"
        while true; do
            read -p "Is this ok [y/N]:" yn
            case $yn in
                [Yy]* ) 
                    echo "Setting Git to be removed";
                    UNINSTALL_GIT=1
                    # For Mac OS X
                    #Navigate to /Library/Git/GitVirtualMachines and remove the directory whose name matches the following format:*
                    #    /Library/Git/GitVirtualMachines/jdk<major>.<minor>.<macro[_update]>.jdk
                    #For example, to uninstall 7u6:
                    #    % rm -rf jdk1.7.0_06.jdk
                
                    # For Linux
                    # sudo rm -rf /opt/vagrant
                    # sudo rm /usr/bin/vagrant
                
                    # User Dir
                    # ~/.vagrant.d
                    INSTALL_GIT=1
                    break;;
                [Nn]* ) echo "Skipping"; break;;
                * ) echo "Please answer yes or no.";;
            esac
        done
    
    fi
else
    # Git is not installed
    INSTALL_GIT=1
    echo "Not Installed"
fi



# Install Git
if [ -n "$INSTALL_GIT" ] ; then
    echo "Install Git"
    GIT_FILE="$HOME/Downloads/git-1.8.4.2-intel-universal-snow-leopard.dmg"
    if [ ! -d "$GIT_FILE" ] ; then
        # Find version here
        # curl -L --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com;" http://download.oracle.com/otn-pub/git/jdk/7u51-b13/jdk-7u51-macosx-x64.dmg -o jdk-7u51-macosx-x64.dmg
        # http://download.oracle.com/otn-pub/git/jdk/7u51-b13/jdk-7u51-macosx-x64.dmg
        # http://download.oracle.com/otn-pub/git/jdk/7u51-b13/jdk-7u51-linux-x64.rpm
        
        curl -L https://git-osx-installer.googlecode.com/files/git-1.8.4.2-intel-universal-snow-leopard.dmg -o $GIT_FILE
    fi
    VOLUME_PATH_GIT='/Volumes/Git 1.8.4.2 Snow Leopard Intel Universal/'
    PACKAGE_NAME_GIT='git-1.8.4.2-intel-universal-snow-leopard.pkg'
    
    hdiutil attach $GIT_FILE
    
    if [ -n "$INSTALL_GIT" ] ; then
        sudo "${VOLUME_PATH_GIT}uninstall.sh"
    fi
    
    sudo installer -package "${VOLUME_PATH_GIT}${PACKAGE_NAME_GIT}" -target '/Volumes/Macintosh HD'
    sudo "${VOLUME_PATH_GIT}setup git PATH for non-terminal programs.sh"
    
    hdiutil detach "$VOLUME_PATH_GIT"
    
    NEW_VERSION_GIT=`git --version | awk '{print $3}'`
    
    if [ "$VERSION_GIT" == "$NEW_VERSION_GIT" ] ; then
        echo "Installed git version isn't matching so creating symbolic link to correct version"
        sudo mv /usr/bin/git /usr/bin/git-{$VERSION_GIT}
        sudo ln -s /usr/local/git/bin/git /usr/bin/git
        TEST_VERSION_GIT=`git --version | awk '{print $3}'`
        if [ "$VERSION_GIT" == "$TEST_VERSION_GIT" ] ; then
            echo "Didn't work!"
            echo ""
            echo "YOU!!!!!"
            echo " Need to investigate why GIT didn't update properly, probably a path issue"
            echo "Should install git to /usr/local/git"
            echo "which git"
            echo "git --version"
            echo "ls -al `which git`"
        else
            echo "INSTALLED: [ Git ]"
            printf "\t"
            echo "$TEST_VERSION_GIT"
        fi
    fi
    
    echo "Remove downloaded file ($GIT_FILE) ?"
    while true; do
        read -p "Is this ok [y/N]:" yn
        case $yn in
            [Yy]* ) 
                rm $GIT_FILE
                break;;
            [Nn]* ) echo "Skipping"; break;;
            * ) echo "Please answer yes or no.";;
        esac
    done
fi

# BASE_DIR=$(cd $(dirname $0);  pwd -P)
# ansible-playbook $BASE_DIR/helloworld_local.yaml -i $BASE_DIR/inventoryfile