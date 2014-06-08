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
# sudo ln -sf bash /bin/sh should be done for Ubuntu in case if source command doesn't work
sudo ln -sf bash /bin/sh
source $BASE_DIR/bootstrap/os_meta_info.sh
#./bootstrap/os_meta_info.sh

# installing developement tools withch are required to build and run softwares in linux
echo ""
echo "[INFO]: Installing common developement tools*************************************"
echo ""

if [ $OS_DISTRO == "CentOS" ] ; then
    #dkms for dynamic kernal module support;kernel-devel for kernel soruce
    # and some of other below components are required by virtualbox
    sudo yum install binutils qt gcc make patch libgomp glibc-headers glibc-devel \
    kernel-headers kernel-devel dkms alsa-lib cairo cdparanoia-libs fontconfig freetype \
    gstreamer gstreamer-plugins-base gstreamer-tools iso-codes lcms-libs libXft libXi \
    libXrandr libXv libgudev1 libjpeg-turbo libmng libogg liboil libthai libtheora libtiff \
    libvisual libvorbis mesa-libGLU pango phonon-backend-gstreamer pixman qt-sqlite \
    qt-x11 libudev libXmu SDL-static libxml2-devel libxslt-devel

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
    libxrender1 libxt6 libxxf86vm1 mysql-common qdbus ttf-dejavu-core x11-common libxml2 libxml2-dev libxslt1-dev
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

if [ ! $INSTALLED == 0 ] ; then
	echo "[INFO] $OS_NAME is current OS"
	echo "INSTALLING: [ curl ]"
	# determining os distribution in case of linux and taking action accordingly
	while true; do
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
	done
	echo "INSTALLED: [ curl installed successfully]"
else
    echo "INSTALLED: [ curl ]"
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
    
   while true; do
	   case $OS_NAME in
	        "Linux" )
	            echo "[INFO] $OS_NAME is current OS"
	            # determining os distribution in case of linux and taking action accordingly
	            case $OS_DISTRO in
	                "CentOS" )
	                    echo "[INFO] $OS_DISTRO-$OS_NAME Proceeding"
	                    sudo yum install python-setuptools
	                    break;;
	                "Ubuntu" )
	                    echo "[INFO] $OS_DISTRO-$OS_NAME Proceeding"
	                    sudo apt-get install -y python-setuptools
	                    break;;
	                * )
	                   #Cases for other Distros such as Debian,Ubuntu,SuSe,Solaris etc may come here 
	                   echo "Script for $OS_NAME "-" $OS_DISTRO has not been tested yet."
	                   echo "Submit Patch to https://github.com/DemandCube/developer-setup."
	                   break;;
	            esac
	            break;;
	        "Darwin" )
	           echo "Script for $OS_NAME  has not been tested yet."
	           echo "Submit Patch to https://github.com/DemandCube/developer-setup."
	           break;;
	        * )
	           #Cases for other OS such as Windows may come here 
	           echo "Script for $OS_NAME  has not been tested yet."
	           echo "Submit Patch to https://github.com/DemandCube/developer-setup."
	           break;;
	    esac
    done
    #curl http://python-distribute.org/distribute_setup.py -o distribute_setup.py
    #sudo python distribute_setup.py
    #sudo rm distribute_setup.py
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
                    sudo pip install paramiko PyYAML jinja2 httplib2    
                    sudo pip install ansible
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
    break
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
while true; do
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
                while true; do
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
                done
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
done


########################################
########################################
####    
####   INSTALL VAGRANT
####
########################################
########################################

# variable declarations                        
INSTALL_VAGRANT=''
REQUIRED_VAGRANT_VERSION=1.5.2
VERSION_VAGRANT=''
VAGRANT_DOWNLOAD_URL=''
VAGRANT_INSTALL_CMD=''
VAGRANT_FILE=''

# Test if Vagrant is installed
command -v vagrant >/dev/null 2>&1
INSTALLED=$?
 
# Test if already installed
if [ $INSTALLED == 0 ] ; then
    #echo "Vagrant is already installed."
    echo ""
    
    VERSION_VAGRANT=`vagrant -v | awk '{ print $2 }'`                
    
    echo "INSTALLED: [ Vagrant ]"
    printf "\t"
    echo "$VERSION_VAGRANT"  
    
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
                    #Determining OS and taking action accordingly
                    case $OS_NAME in
                        "Linux" )
                            echo  "$OS_NAME is current OS. "
                            echo ""

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
                        "Darwin" )
                            echo -e "Mac OS X Proceeding"

                            break;;
                        * )
                            #Cases for other Distros such as Windows etc may come here 
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
    
    # Determining OS and talking actiion accordingly 
    while true; do
    case $OS_NAME in              
        "Linux" )
            echo  "$OS_NAME is current OS"
            echo ""
            
            # Determining OS Distribution and taking install action accordingly
            while true; do
            case $OS_DISTRO in
                "CentOS" )
                   echo "$OS_DISTRO - $OS_NAME Proceeding."        
                   VAGRANT_FILE="$HOME/Downloads/Vagrant-$REQUIRED_VAGRANT_VERSION.rpm" 
                   VAGRANT_DOWNLOAD_URL="https://dl.bintray.com/mitchellh/vagrant/vagrant_1.5.2_x86_64.rpm"
                   VAGRANT_INSTALL_CMD='sudo rpm -ivh'
                   break;;
                "Ubuntu" )
                   echo "$OS_DISTRO-$OS_ARCH - $OS_NAME Proceeding."
                   # Determining OS Architecture
                   while true; do
                   case $OS_ARCH in
                       # 32-bit os
                       "i686" )
                           echo "$OS_DISTRO - $OS_NAME Proceeding."
                           VAGRANT_FILE="$HOME/Downloads/Vagrant-$REQUIRED_VAGRANT_VERSION.deb"
                           VAGRANT_DOWNLOAD_URL="https://dl.bintray.com/mitchellh/vagrant/vagrant_1.5.2_i686.deb"
                           VAGRANT_INSTALL_CMD="sudo dpkg -i"
                           break;;
                       # 64-bit os
                       "x86_64" )
                           VAGRANT_FILE="$HOME/Downloads/Vagrant-$REQUIRED_VAGRANT_VERSION.deb"
                           VAGRANT_DOWNLOAD_URL="https://dl.bintray.com/mitchellh/vagrant/vagrant_1.5.2_x86_64.deb"
                           VAGRANT_INSTALL_CMD="sudo dpkg -i"
                           break;;
                        # other
                        * )
                          #Cases for other Distros such as Debian,Ubuntu,SuSe,Solaris etc may come here 
                          echo "Script for $OS_NAME "-" $OS_DISTRO has not been tested yet."
                          echo "Submit Patch to https://github.com/DemandCube/developer-setup."
                          break;;
                   esac
                   done
                   break;;
                * )
                   #Cases for other Distros such as Debian,Ubuntu,SuSe,Solaris etc may come here 
                   echo "Script for $OS_NAME "-" $OS_DISTRO has not been tested yet."
                   echo "Submit Patch to https://github.com/DemandCube/developer-setup."
                   break;;                                       
            esac
            done
            break;;

        "Darwin" )
            echo "Mac OS X Proceeding"
            echo ""
            VAGRANT_FILE="$HOME/Downloads/Vagrant-$REQUIRED_VAGRANT_VERSION.dmg"
            VAGRANT_DOWNLOAD_URL="https://dl.bintray.com/mitchellh/vagrant/vagrant_1.5.2.dmg"
            VAGRANT_INSTALL_CMD="hdiutil attach $VAGRANT_FILE && sudo installer -package /Volumes/Vagrant/Vagrant.pkg -target '/Volumes/Macintosh HD' && hdiutil detach /Volumes/Vagrant/"
            break;;
        * )
           #Cases for other OS such as Windows etc may come here 
           echo "Script for $OS_NAME has not been tested yet."
           echo "Submit Patch to https://github.com/DemandCube/developer-setup."
           break;;                 
    esac
    done

    # Test if Vagrant needs to be downloaded
    if [ ! -d "$VAGRANT_FILE" ] ; then
        # Find version here
        # http://download.virtualbox.org/virtualbox/
        
        # check if Downloads directory exists, other create it
        if [ ! -d "$HOME/Downloads" ]; then
            mkdir "$HOME/Downloads"
        fi
        curl -Lk $VAGRANT_DOWNLOAD_URL -o $VAGRANT_FILE
    fi
    # Installing downloaded file
    while true; do
    case $OS_NAME in
        "Linux" )
            $VAGRANT_INSTALL_CMD $VAGRANT_FILE
            break;;
        "Darwin" )
        eval $VAGRANT_INSTALL_CMD
        break;;   
    esac 
    done
    # Removing downloaded file
    rm $VAGRANT_FILE
fi    


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
                    echo "[INFO] Removing Java";
                      
                    #http://www.java.com/en/download/help/linux_uninstall.xml                   
                    ######################RPM uninstall####################################
                    # Note: If you have RPM on your Linux box, you should first find out if Java is already installed using RPM. If Java is not installed using RPM, you should skip reading.

                    # Open Terminal Window
                    # Login as the super user
                    # Try to find jre package by typing: rpm -qa
                    # If RPM reports a package similar to jre-<version>-fcs, then Java is installed with RPM.

                    # Note: Normally, you do not need to uninstall Java with RPM, because RPM is able to uninstall the old version of Java when installing a new version! You may skip reading, unless you want to remove Java permanently.
                    # To uninstall Java, type: rpm -e jre-<version>-fcs

                    #######################Self-extracting file uninstall##################

                    # Find out if Java is installed in some folder. Common locations are /usr/java/jre_<version> or /opt/jre_nb/jre_<version>/bin/java/
                    # When you have located the folder, you may delete folder.
                    # Warning: You should be certain that Java is not already installed using RPM before removing the folder.
                    # Type: rm -r jre<version>
                    # For example: rm -r jre1.6.0

                    # For Mac OS X
                    #Navigate to /Library/Java/JavaVirtualMachines and remove the directory whose name matches the following format:*
                    #    /Library/Java/JavaVirtualMachines/jdk<major>.<minor>.<macro[_update]>.jdk
                    #For example, to uninstall 7u6:
                    #  % rm -rf jdk1.7.0_06.jdk
                
                    # For Linux
                    # sudo rm -rf /opt/vagrant
                    # sudo rm /usr/bin/vagrant
                
                    # User Dir
                    # ~/.vagrant.d
                    INSTALL_JAVA=1
                    #Determining OS and taking remove action accordingly
                    while true; do
	                    case $OS_NAME in
	                        "Linux" )
	                            echo  "[INFO] $OS_NAME is current OS. "
	                           
	                            #Determining OS Distribution and taking remove action accordingly
	                            while true; do
		                            case $OS_DISTRO in
		                                "CentOS" )
		                                   echo -e "[INFO] $OS_DISTRO - $OS_NAME Proceeding.\n"        
		                                                 
		                                   break;;
		                                "Ubuntu" )
		                                   echo -e "[INFO::] $OS_DISTRO - $OS_NAME Proceeding.\n"
		                                   
		                                   break;;
		                                *)
		                                   #Cases for other Distros such as Debian,Ubuntu,SuSe,Solaris etc may come here 
		                                   echo "[INFO] Script for $OS_NAME "-" $OS_DISTRO has not been tested yet."
		                                   echo "[INFO] Submit Patch to https://github.com/DemandCube/developer-setup."
		                                   break;;                                       
		                            esac
	                            done
	                            break;;
	                        "Darwin" )
	                            echo -e "Mac OS X Proceeding"
	                            echo  "[INFO] Script was unable to uninstall/remove java! Please uninstall/remove it manually"
	                            echo  "[INFO] Cause::: No Script to uninstall. Please add Script to uninstall****************"
	                            break;;
	                        * )
	                            #Cases for other OS such as Windows etc may come here 
	                            echo "Script for $OS_NAME "-" $OS_DISTRO has not been tested yet."
	                            echo "Submit Patch to https://github.com/DemandCube/developer-setup."
	                            break;;
	                    esac
                    done
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
    while true; do
	    case $OS_NAME in              
	        "Linux" )
	           echo  "$OS_NAME is current OS"
	           echo ""
	           while true; do
		           case $OS_DISTRO in
		               "CentOS" )
		                   echo "$OS_DISTRO-$OS_NAME Proceeding..."
		                   echo ""
		                   JAVA_FILE="$HOME/Downloads/jdk-7u51-linux-x64.rpm"
		                   JAVA_DOWNLOAD_URL="http://download.oracle.com/otn-pub/java/jdk/7u51-b13/jdk-7u51-linux-x64.rpm"
		                   JAVA_INSTALL_CMD="sudo rpm -ivh $JAVA_FILE"
		                   break ;;
		                "Ubuntu" )
		                   echo "$OS_DISTRO-$OS_ARCH - $OS_NAME Proceeding."
		                   # Determining OS Architecture
		                   case $OS_ARCH in
		                       # 32-bit os
		                       "i686" )
		                            JAVA_FILE="$HOME/Downloads/jdk-7u51-linux-x64.tar.gz"
		                            JAVA_DOWNLOAD_URL="http://download.oracle.com/otn-pub/java/jdk/7u51-b13/jdk-7u51-linux-i586.tar.gz"
		                            JAVA_INSTALL_CMD="cd /opt && sudo tar -xzf $JAVA_FILE && echo 'export JAVA_HOME=/opt/jdk1.7.0_51' >> $HOME/.bashrc && echo 'export PATH=$PATH:$JAVA_HOME/bin' >> $HOME/.bashrc && cd $HOME && source ~/.bashrc"
		                           break;;
		                       # 64-bit os
		                       "x86_64" )
		                            JAVA_FILE="$HOME/Downloads/jdk-7u51-linux-x64.tar.gz"
		                            JAVA_DOWNLOAD_URL="http://download.oracle.com/otn-pub/java/jdk/7u51-b13/jdk-7u51-linux-x64.tar.gz"
		                            JAVA_INSTALL_CMD="cd /opt && sudo tar -xzf $JAVA_FILE && echo 'export JAVA_HOME=/opt/jdk1.7.0_51' >> $HOME/.bashrc && echo 'export PATH=$PATH:$JAVA_HOME/bin' >> $HOME/.bashrc && cd $HOME && source ~/.bashrc"
		                           break;;
		                        # other
		                        * )
		                          #Cases for other Distros such as Debian,Ubuntu,SuSe,Solaris etc may come here 
		                          echo "Script for $OS_NAME "-" $OS_DISTRO has not been tested yet."
		                          echo "Submit Patch to https://github.com/DemandCube/developer-setup."
		                          break;;
		                   esac
		                   break;;                  
		                   
		                * )
		                  #Cases for other Distros such as Debian,Ubuntu,SuSe etc may come here 
		                  echo "Script for $OS_DISTRO has not been tested yet."
		                  echo "Submit Patch to https://github.com/DemandCube/developer-setup."
		                  break ;;
		           esac
		   done
	           break ;;
	        "Darwin" )
	           echo "Mac OS X Proceeding..."
	           echo ""
	           JAVA_FILE="$HOME/Downloads/jdk-7u51-macosx-x64.dmg"
	           JAVA_DOWNLOAD_URL='http://download.oracle.com/otn-pub/java/jdk/7u51-b13/jdk-7u51-macosx-x64.dmg'
	           JAVA_INSTALL_CMD="hdiutil attach $JAVA_FILE && sudo installer -package '/Volumes/JDK 7 Update 51/JDK 7 Update 51.pkg' -target '/Volumes/Macintosh HD' && hdiutil detach '/Volumes/JDK 7 Update 51/'"
	           break ;;
	        * )
	           #Cases for other OS such as Windows etc may come here 
	           echo "Script for $OS_NAME has not been tested yet."
	           echo "Submit Patch to https://github.com/DemandCube/developer-setup."
	           break;; 
	    esac
    done
    if [ ! -d "$JAVA_FILE" ] ; then
        # Find version here
        # curl -L --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com;" http://download.oracle.com/otn-pub/java/jdk/7u51-b13/jdk-7u51-macosx-x64.dmg -o jdk-7u51-macosx-x64.dmg
        # http://download.oracle.com/otn-pub/java/jdk/7u51-b13/jdk-7u51-macosx-x64.dmg
        # http://download.oracle.com/otn-pub/java/jdk/7u51-b13/jdk-7u51-linux-x64.rpm  
        
        # check if Downloads directory exists, other create it
        if [ ! -d "$HOME/Downloads" ]; then
            mkdir "$HOME/Downloads"
        fi
        echo "Downloading Java..." 
        
        # OLD STYLE [not working since @DATE Mon April 7 2014]
        #curl -L --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com;" $JAVA_DOWNLOAD_URL -o $JAVA_FILE
        
        # NEW STYLE
        echo "JAVA output location  = $JAVA_FILE"
        echo "JAVA installation command = $JAVA_INSTALL_CMD"
        curl -L --header "Cookie: oraclelicense=accept-securebackup-cookie" $JAVA_DOWNLOAD_URL -o $JAVA_FILE
    fi 
    while true; do
	    case $OS_DISTRO in
	        "CentOS" )
        	 	$JAVA_INSTALL_CMD
        	 	break;;
        	 * )
            		eval $JAVA_INSTALL_CMD
            		break;;      
	    esac
    done
    rm $JAVA_FILE
fi

########################################
########################################
####    
####   INSTALL GIT
####
########################################
########################################

INSTALL_GIT=''
VERSION_GIT=''
REQUIRED_GIT_VERSION=1.8
GIT_FILE=''
GIT_DOWNLOAD_URL=''
GIT_INSTALL_CMD=''
UNINSTALL_GIT=''

command -v git --version >/dev/null 2>&1
INSTALLED=$?
echo ""

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
            read -p "Is this ok [y/N]:" yn
            while true; do
            case $yn in
                [Yy]* ) 
                    echo "Setting Git to be removed";
                    UNINSTALL_GIT=1
                    while true; do
	                    case $OS_NAME in
	                         "Linux" )
	                            echo "$OS_NAME Proceeding"
	                            while true; do
		                            case $OS_DISTRO in
		                                "CentOS" )
		                                    echo "$OS_DISTRO-$OS_NAME Proceeding"
		                                    GIT=`which git`
		                                    sudo rm $GIT
		                                    #### also git direcotry in home needs to be removed
		                                    break;;
		                                "Ubuntu" )
		                                    echo "$OS_DISTRO-$OS_NAME Proceeding"
		                                    GIT=`which git`
		                                    sudo rm $GIT
		                                    #### also git direcotry in home needs to be removed
		                                    break;;
		                                * )
		                                     #Cases for other Distros such as Debian,Ubuntu,SuSe etc may come here 
		                                      echo "Script for $OS_DISTRO has not been tested yet."
		                                      echo "Submit Patch to https://github.com/DemandCube/developer-setup."
		                                    break;;
		                            esac
		                    done
	                            break;;
	                         "Darwin" )
	                            echo "Mac OS X Proceeding"
	                            # For Mac OS X
	                            #Navigate to /Library/Git/GitVirtualMachines and remove the directory whose name matches the following format:*
	                            #    /Library/Git/GitVirtualMachines/jdk<major>.<minor>.<macro[_update]>.jdk
	                            #For example, to uninstall 7u6:
	                            #    % rm -rf jdk1.7.0_06.jdk
	                            GIT=`which git`
	                            sudo rm $GIT
	                            #### also needs git direcotry in home removed
	                            break;;
	                          * )
	                            #Cases for other Distros such as Debian,Ubuntu,SuSe etc may come here 
	                            echo "Script for $OS_NAME has not been tested yet."
	                            echo  "Submit Patch to https://github.com/DemandCube/developer-setup."
	                            break;;
	                    esac   
	            done
                    INSTALL_GIT=1
                    break;;
                [Nn]* ) echo "Skipping"; break;;
                * ) 
                echo "Please answer yes or no.";;
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

    while true; do
	    case $OS_NAME in
	      "Linux" )
	         echo "$OS_NAME Proceeding"
	         while true; do
		         case $OS_DISTRO in
		             "CentOS" )
		                 echo "$OS_DISTRO-$OS_NAME Proceeding"
		                 GIT_FILE="$HOME/Downloads/git-1.8.5.3.tar.gz"
		                 GIT_DOWNLOAD_URL="http://git-core.googlecode.com/files/git-1.8.5.3.tar.gz"
		                 GIT_INSTALL_CMD="sudo yum install curl-devel expat-devel gettext-devel zlib-devel perl-ExtUtils-MakeMaker asciidoc xmlto openssl-devel && cd $HOME/Downloads && tar -xzf $GIT_FILE && cd git-1.8.5.3 && ./configure --prefix=/usr --without-tcltk  && make && sudo make install"
		                 break;;
		             "Ubuntu" )
		                 echo "$OS_DISTRO-$OS_NAME Proceeding"
		                 GIT_FILE="$HOME/Downloads/git-1.8.5.3.tar.gz"
		                 GIT_DOWNLOAD_URL="http://git-core.googlecode.com/files/git-1.8.5.3.tar.gz"
		                 GIT_INSTALL_CMD="sudo apt-get install libcurl4-gnutls-dev libexpat1-dev gettext zlib1g-dev libz-dev libssl-dev &&  cd $HOME/Downloads && tar -xzf $GIT_FILE && cd git-1.8.5.3 && ./configure --prefix=/usr --without-tcltk && make && sudo make install"
		                 break;;
		             * )
		                 #Cases for other Distros such as Debian,Ubuntu,SuSe etc may come here 
		                 echo "Script for $OS_DISTRO has not been tested yet."
		                 echo "Submit Patch to https://github.com/DemandCube/developer-setup."
		                 break;;
		         esac
		  done
	          if [ ! -d "$GIT_FILE" ] ; then
	            #checking for Downloads folder
	            if [ ! -d "$HOME/Downloads" ]; then
	                mkdir "$HOME/Downloads"
	            fi  
	            curl -Lk $GIT_DOWNLOAD_URL -o $GIT_FILE
	          fi 
	          #http://stackoverflow.com/questions/2005192/how-to-execute-a-bash-command-stored-as-a-string-with-quotes-and-asterisk
	          eval $GIT_INSTALL_CMD
	          rm $GIT_FILE
	          break;;
	      "Darwin" )
	        echo "Mac OS X Proceeding"
	        GIT_FILE="$HOME/Downloads/git-1.8.4.2-intel-universal-snow-leopard.dmg"
	        if [ ! -d "$GIT_FILE" ] ; then
	            # Find version here
	            # curl -L --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com;" http://download.oracle.com/otn-pub/git/jdk/7u51-b13/jdk-7u51-macosx-x64.dmg -o jdk-7u51-macosx-x64.dmg
	            # http://download.oracle.com/otn-pub/git/jdk/7u51-b13/jdk-7u51-macosx-x64.dmg
	            # http://download.oracle.com/otn-pub/git/jdk/7u51-b13/jdk-7u51-linux-x64.rpm
	            
	            # check if Downloads directory exists, other create it
	            if [ ! -d "$HOME/Downloads" ]; then
	                mkdir "$HOME/Downloads"
	            fi            
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
	        break;;
	      * )
	        #Cases for other Distros such as Debian,Ubuntu,SuSe etc may come here 
	        echo "Script for $OS_NAME has not been tested yet."
	        echo "Submit Patch to https://github.com/DemandCube/developer-setup."
	        break;;
	   esac
   done
fi
echo "Deployment successfully completed..."
# BASE_DIR=$(cd $(dirname $0);  pwd -P)
# ansible-playbook $BASE_DIR/helloworld_local.yaml -i $BASE_DIR/inventoryfile
