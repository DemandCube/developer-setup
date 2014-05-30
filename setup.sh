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
        while true; do
            read -p "Is this ok [y/N]:" yn
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
    
# BASE_DIR=$(cd $(dirname $0);  pwd -P)
# ansible-playbook $BASE_DIR/helloworld_local.yaml -i $BASE_DIR/inventoryfile


