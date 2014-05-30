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


# present working directory
BASE_DIR=$(cd $(dirname $0);  pwd -P)

# including os_meta_info.sh file which provides following meta information
#### OS_NAME
#### OS_DISTRO
#### OS_DISTRO_BASED_ON 
#### OS_PSUEDO_NAME
#### OS_REVISION
#### OS_KERNEL_VER
#### OS_ARCH
sudo ln -sf bash /bin/sh
source $BASE_DIR/bootstrap/os_meta_info.sh
#./bootstrap/os_meta_info.sh

# installing developement tools withch are required to build and run softwares in linux
echo ""
echo "[INFO]: Installing common developement tools************************************"
echo ""
if [ $OS_DISTRO == "CentOS" ] ; then
    #dkms for dynamic kernal module support;kernel-devel for kernel soruce
    # and some of other below components are required by virtualbox
    sudo yum install binutils qt gcc make patch libgomp glibc-headers glibc-devel \
    kernel-headers kernel-devel dkms alsa-lib cairo cdparanoia-libs fontconfig freetype \
    gstreamer gstreamer-plugins-base gstreamer-tools iso-codes lcms-libs libXft libXi \
    libXrandr libXv libgudev1 libjpeg-turbo libmng libogg liboil libthai libtheora libtiff \
    libvisual libvorbis mesa-libGLU pango phonon-backend-gstreamer pixman qt-sqlite \
    qt-x11 libudev libXmu SDL-static

    #######################...........OR..........############################################
    # sudo yum install gcc-c++ make libcap-devel libcurl-devel libIDL-devel libstdc++-static \
    # libxslt-devel libXmu-devel openssl-devel pam-devel pulseaudio-libs-devel \
    # python-devel qt-devel SDL_ttf-devel SDL-static texlive-latex wine-core \
    # device-mapper-devel wget subversion subversion-gnome kernel-devel \
    # glibc-static zlib-static glibc-devel.i686 libstdc++.i686 libpng-devel
    ######################....if above first set of commands are insufficient...###############

elif [ $OS_DISTRO == "Ubuntu" ] ; then
    # dkms for dynamic kernal module support;kernel-devel for kernel soruce
    # and some of other below components are required by virtualbox
    sudo apt-get install gcc make linux-headers-$(uname -r) dkms build-essential fontconfig fontconfig-config libasound2 libasyncns0 libaudio2 libavahi-client3 libavahi-common-data libavahi-common3 libcaca0 \
    libcups2 libflac8 libfontconfig1 libgl1-mesa-dri libgl1-mesa-glx libglapi-mesa libice6 libjpeg-turbo8 libjpeg8 libjson0 liblcms1 \
    libllvm3.0 libmng1 libmysqlclient18 libogg0 libpulse0 libpython2.7 libqt4-dbus libqt4-declarative libqt4-network libqt4-opengl \
    libqt4-script libqt4-sql libqt4-sql-mysql libqt4-xml libqt4-xmlpatterns libqtcore4 libqtgui4 libsdl1.2debian libsm6 libsndfile1 \
    libtiff4 libvorbis0a libvorbisenc2 libvpx1 libx11-xcb1 libxcb-glx0 libxcursor1 libxdamage1 libxfixes3 libxi6 libxinerama1 libxmu6 \
    libxrender1 libxt6 libxxf86vm1 mysql-common qdbus ttf-dejavu-core x11-common
fi

#######################################
#######################################
###
### Installation of python,easy_install
### pip,and ansible with little change
### is same for Ubuntu,Mac,and CentOS
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
####   INSTALL CURL
####
########################################
########################################

# Test if easy_install if not install manually
command -v curl >/dev/null 2>&1
INSTALLED=$?
echo ""
while true; do
if [ ! $INSTALLED == 0 ] ; then
	echo "[INFO] $OS_NAME is current OS"
	echo "INSTALLING: [ curl ]"
	# determining os distribution in case of linux and taking action accordingly
	case $OS_DISTRO in
        	"CentOS" ) 
        		sudo yum install curl-devel 
        		break;;

		"Ubuntu" ) 
			sudo apt-get install -y curl 
			break;;
 		
		* ) 	#Cases for other Distros such as Debian,SuSe,Solaris etc
			echo "Install curl"
			break;;
	esac
	echo "INSTALLED: [ curl installed successfully]"
else
    echo "INSTALLED: [ curl ]"
fi
done

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
    sudo apt-get install -y python-setuptools
    curl http://python-distribute.org/distribute_setup.py -o distribute_setup.py
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
# pip >= 1.5.4
PIP_VERSION=1.5.4
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
while true; do 
if [ ! $INSTALLED == 0 ] ; then
    echo "INSTALLING: [ ansible ]"
    # determining OS and taking action accordingly
    case $OS_NAME in
        "Linux" )
            echo "[INFO] $OS_NAME is current OS"
            # determining os distribution in case of linux and taking action accordingly
            case $OS_DISTRO in
                "CentOS" )
                    echo "[INFO] $OS_DISTRO-$OS_NAME Proceeding"
                    #sudo yum groupinstall "Development Tools"
                    sudo yum install python-devel
                    sudo pip install paramiko PyYAML jinja2 httplib2    
                    sudo pip install ansible
                    break;;
                "Ubuntu" )
                    echo "[INFO] $OS_DISTRO-$OS_NAME Proceeding"
                    #sudo apt-get install "build-essential"
                    sudo apt-get install -y python-dev
                    sudo apt-get install -y paramiko PyYAML jinja2 httplib2    
                    sudo apt-get install -y ansible
                    break;;
                * )
                   #Cases for other Distros such as Debian,Ubuntu,SuSe,Solaris etc may come here 
                   echo "Script for $OS_NAME "-" $OS_DISTRO has not been tested yet."
                   echo "Submit Patch to https://github.com/DemandCube/developer-setup."
                   break;;
            esac
            break;;
        "Darwin" )
            # script may be needed here to install python-devel
            sudo pip install paramiko PyYAML jinja2 httplib2    
            sudo pip install ansible
            break;;
        * )
           #Cases for other OS such as Windows may come here 
           echo "Script for $OS_NAME  has not been tested yet."
           echo "Submit Patch to https://github.com/DemandCube/developer-setup."
           break;;
    esac
else
    echo "INSTALLED: [ ansible ]"
    printf "\t"
    ansible --version | awk '{ print $2 }'
fi
done

########################################
########################################
####    
####   INSTALL NOSE
####
########################################
########################################

# variable declarations
REQUIRED_NOSE_VERSION=1.3.0
VERSION_NOSE=''
NOSE_DOWNLOAD_URL='https://pypi.python.org/packages/source/n/nose/nose-1.3.0.tar.gz'
NOSE_INSTALL_CMD='sudo pip install -I'
NOSE_UNISTALL_CMD='sudo pip uninstall -y nose'
INSTALL_NOSE=''

# Test if nose already installed
command -v nosetests >/dev/null 2>&1
INSTALLED=$?
echo ""
if [ $INSTALLED == 0 ] ; then
    # Already installed 
    # test existing version and required version
    # first command outputs full version(eg. nosetests version 1.3.0) and 
    # second command extracts version part
    VERSION_NOSE=`nosetests --version | cut -f3 -d" "`
    echo "INSTALLED: [ nose ]"
    printf "\t"
    echo $VERSION_NOSE
    echo
    # Compare the required and found version
    $BASE_DIR/bootstrap/version_compare.py $VERSION_NOSE $REQUIRED_NOSE_VERSION
    CMP_RESULT=$?    
    # Test if installed version is lower then required version  
    if [ ! $CMP_RESULT -eq 2 ] ; then
        # Remove Nose if not verion: $REQUIRED_NOSE_VERSION      
        echo "[INFO] Current Nose Version: $VERSION_NOSE"
        echo "[INFO] Required Nose Version: $REQUIRED_NOSE_VERSION"
        echo ""                    
        echo "Install Correct Nose (Delete and Install)?"
        while true; do
            read -p "Is this ok [y/N]:" yn
            case $yn in
                [Yy]* )
                      echo "[INFO] Removing nose***********"
                      $NOSE_UNISTALL_CMD
                      INSTALL_NOSE=1
                      break;;         
                [Nn]* ) 
                      echo "No"; break;;
                * ) 
                    echo "Please answer yes or no.";;
            esac
        done
    fi
else
    echo "[INFO] Nose not installed"
    INSTALL_NOSE=1
fi
# test if nose needs to be installed
if [[ -n "$INSTALL_NOSE" ]]; then
    echo "[INFO] Installing nose it was missing"
    echo "INSTALLING: [ nose ]"
    printf "\t"
    $NOSE_INSTALL_CMD $NOSE_DOWNLOAD_URL
    echo "[INFO] nose-$REQUIRED_NOSE_VERSION installed successfully"
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
REQUIRED_VIRTUALBOX_VERSION=4.3.10
VERSION_VIRTUALBOX=''
VIRTUALBOX_DOWNLOAD_URL=''
VIRTUALBOX_INSTALL_CMD=''
VIRTUALBOX_FILE=''

#Determining OS and taking action accordingly
case $OS_NAME in
    "Linux" )
            echo  "[INFO]: $OS_NAME is current OS. "
            # Test if VirtualBox is already installed
            command -v virtualbox >/dev/null 2>&1
            INSTALLED=$?

            if [ $INSTALLED == 0 ] ; then
                echo "[INFO]: VirtualBox is already installed."
                echo ""
                # first command outputs full version(eg. 4.2.6r02546) and second command removes release part of version(eg. r025) 
                VERSION_VIRTUALBOX=`VBoxManage -v | cut -f1 -d"r"`
                #VERSION_VIRTUALBOX=${VERSION_VIRTUALBOX:0:6} 
                echo "INSTALLED: [Virtualbox]"
                printf "\t"
                echo $VERSION_VIRTUALBOX
                echo ""

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
                                       VM="`rpm -qa | grep VirtualBox`"
                                       echo "Removing package-$VM"      
                                       sudo rpm -e "$VM"               
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
                       VIRTUALBOX_DOWNLOAD_URL="http://download.virtualbox.org/virtualbox/4.3.10/VirtualBox-4.3-4.3.10_93012_el6-1.x86_64.rpm"
                       VIRTUALBOX_INSTALL_CMD="sudo rpm -ivh"
                       break;;
                    "Ubuntu" )
                       echo "$OS_DISTRO-$OS_ARCH-$OS_REVISION - $OS_NAME Proceeding."
                       # Determining OS architecture 32-bit or 64-bit
                       case $OS_ARCH in
                           # 32-bit OS
                           "i686" )
                               # Determine OS version
                               case $OS_REVISION in
                                   "12.04" )
                                       VIRTUALBOX_FILE="$HOME/Downloads/VirtualBox-$REQUIRED_VIRTUALBOX_VERSION.deb"
                                       VIRTUALBOX_DOWNLOAD_URL="http://download.virtualbox.org/virtualbox/4.3.10/virtualbox-4.3_4.3.10-93012~Ubuntu~precise_i386.deb"
                                       VIRTUALBOX_INSTALL_CMD="sudo dpkg -i"
                                       break;;
                                   "12.10" )
                                       VIRTUALBOX_FILE="$HOME/Downloads/VirtualBox-$REQUIRED_VIRTUALBOX_VERSION.deb"
                                       VIRTUALBOX_DOWNLOAD_URL="http://download.virtualbox.org/virtualbox/4.3.10/virtualbox-4.3_4.3.10-93012~Ubuntu~raring_i386.deb"
                                       VIRTUALBOX_INSTALL_CMD="sudo dpkg -i"
                                       break;;
                                   "13.04" )
                                       VIRTUALBOX_FILE="$HOME/Downloads/VirtualBox-$REQUIRED_VIRTUALBOX_VERSION.deb"
                                       VIRTUALBOX_DOWNLOAD_URL="http://download.virtualbox.org/virtualbox/4.3.10/virtualbox-4.3_4.3.10-93012~Ubuntu~quantal_i386.deb"
                                       VIRTUALBOX_INSTALL_CMD="sudo dpkg -i"
                                       break;;
                                    * )
                                       echo "[INFO] Current Version of Script doesn't support this architecture of $OS_NAME"        
                                       break;;
                               esac
                               break;;
                            # 64-bit OS
                            "x86_64")
                               # Determine OS version
                               case $OS_REVISION in
                                   "12.04" )
                                       VIRTUALBOX_FILE="$HOME/Downloads/VirtualBox-$REQUIRED_VIRTUALBOX_VERSION.deb"
                                       VIRTUALBOX_DOWNLOAD_URL="http://download.virtualbox.org/virtualbox/4.3.10/virtualbox-4.3_4.3.10-93012~Ubuntu~precise_amd64.deb"
                                       VIRTUALBOX_INSTALL_CMD="sudo dpkg -i"
                                       break;;
                                   "12.10" )
                                       VIRTUALBOX_FILE="$HOME/Downloads/VirtualBox-$REQUIRED_VIRTUALBOX_VERSION.deb"
                                       VIRTUALBOX_DOWNLOAD_URL="http://download.virtualbox.org/virtualbox/4.3.10/virtualbox-4.3_4.3.10-93012~Ubuntu~quantal_amd64.deb"
                                       VIRTUALBOX_INSTALL_CMD="sudo dpkg -i"
                                       break;;
                                   "13.04" )
                                       VIRTUALBOX_FILE="$HOME/Downloads/VirtualBox-$REQUIRED_VIRTUALBOX_VERSION.deb"
                                       VIRTUALBOX_DOWNLOAD_URL="http://download.virtualbox.org/virtualbox/4.3.10/virtualbox-4.3_4.3.10-93012~Ubuntu~raring_amd64.deb"
                                       VIRTUALBOX_INSTALL_CMD="sudo dpkg -i"
                                       break;;
                                    * )
                                       echo "[INFO] Current Version of Script doesn't support this architecture of $OS_NAME"        
                                       break;;
                               esac
                               break;;
                            # other than 32-bit and 64-bit
                            * ) 
                               echo "[INFO] Current Version of Script doesn't support this architecture of $OS_NAME"
                               break;;
                       esac
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
                    
                    # check if Downloads directory exists, other create it
                    if [ ! -d "$HOME/Downloads" ]; then
                        mkdir "$HOME/Downloads"
                    fi
                    curl -Lk $VIRTUALBOX_DOWNLOAD_URL -o $VIRTUALBOX_FILE
                    echo "[INFO::] Downloaded"
                fi
                # Installing downloaded file
                $VIRTUALBOX_INSTALL_CMD $VIRTUALBOX_FILE
                sudo service vboxdrv setup                
                # Removing downloaded file
                rm $VIRTUALBOX_FILE
            fi
            break;;
    "Darwin")
        echo "Mac OS X - Proceeding"

        # $BASE_DIR/bootstrap/mac_app_installed.sh
        # $BASE_DIR/bootstrap/mac_app_version.sh
        # org.virtualbox.app.VirtualBox
        $BASE_DIR/bootstrap/mac_app_installed.sh org.virtualbox.app.VirtualBox
        INSTALLED=$?
        echo ""

        REQUIRED_VIRTUALBOX_VERSION=4.3.10
        REQUIRED_VIRTUALBOX_URL=http://download.virtualbox.org/virtualbox/4.3.10/VirtualBox-4.3.10-93012-OSX.dmg

        # https://github.com/noitcudni/vagrant-ae

        if [ $INSTALLED == 1 ] ; then
            # VirtualBox is installed
            VERSION_VIRTUALBOX=`$BASE_DIR/bootstrap/mac_app_version.sh org.virtualbox.app.VirtualBox`

            echo "INSTALLED: [ VirtualBox ]"
            printf "\t"
            echo "$VERSION_VIRTUALBOX"
            # Test virtualbox in system
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
                                        
                                        # Test if there are any running VM's and shut them down
                                        # VBoxManage controlvm `VBoxManage list runningvms | awk '{ print $1 }' | tr -d '"' | head -n 1` poweroff
                                        VM_COUNT=`VBoxManage list runningvms | wc -l | awk '{ print $1 }'`
                                        while [ $VM_COUNT -gt 0 ]
                                        do
                                          VBoxManage controlvm `VBoxManage list runningvms | awk '{ print $1 }' | tr -d '"' | head -n 1` poweroff
                                          VM_COUNT=`VBoxManage list runningvms | wc -l | awk '{ print $1 }'`
                                        done
                                        
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
                
                # check if Downloads directory exists, other create it
                if [ ! -d "$HOME/Downloads" ]; then
                    mkdir "$HOME/Downloads"
                fi
                curl -Lk ${REQUIRED_VIRTUALBOX_URL} -o $VIRTUALBOX_FILE
            fi
            hdiutil attach $VIRTUALBOX_FILE
            sudo installer -package /Volumes/VirtualBox/VirtualBox.pkg -target '/Volumes/Macintosh HD'
            hdiutil detach /Volumes/VirtualBox/
            
            rm $VIRTUALBOX_FILE
        fi
    break;;
    * )
       #Cases for other OS such as Windows may come here 
       echo "Script for $OS_NAME has not been tested yet."
       echo "Submit Patch to https://github.com/DemandCube/developer-setup."
       break;;
esac
