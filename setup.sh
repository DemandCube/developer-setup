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
	         # eval "$GIT_INSTALL_CMD"
	          sudo apt-get install libcurl4-gnutls-dev libexpat1-dev gettext zlib1g-dev libz-dev libssl-dev;
	          cd $HOME/Downloads;
	          tar -xzf $GIT_FILE;
	          cd git-1.8.5.3;
	          ./configure --prefix=/usr --without-tcltk;
	          make;
	          sudo make install
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
