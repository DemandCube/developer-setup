# variable declarations
BASE_DIR=$(cd $(dirname $0);  pwd -P)
INSTALL_VIRTUALBOX=''
REQUIRED_VIRTUALBOX_VERSION=4.2.16
REQUIRED_VAGRANT_VERSION=1.3.5

# Test if VirtualBox is installed
command -v virtualbox >/dev/null 2>&1
INSTALLED=$?

if [ $INSTALLED == 0 ] ; then
	echo "VirtualBox is installed."
	#  VirtualBox is installed
    VERSION_VIRTUALBOX=`VBoxManage -v`
    VERSION_VIRTUALBOX=${VERSION_VIRTUALBOX:0:5} 

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
						INSTALL_VIRTUALBOX=1
						sudo yum remove virtualbox-$VERSION_VIRTUALBOX					
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
    VIRTUALBOX_FILE="$HOME/Downloads/VirtualBox-$REQUIRED_VIRTUALBOX_VERSION.rpm"
    if [ ! -d "$VIRTUALBOX_FILE" ] ; then
        # Find version here
        # http://download.virtualbox.org/virtualbox/
        curl -Lk http://dlc.sun.com.edgesuite.net/virtualbox/4.3.6/VirtualBox-4.3-4.3.6_91406_el6-1.x86_64.rpm -o $VIRTUALBOX_FILE
    fi
    sudo rpm -Uvh $VIRTUALBOX_FILE
    
    rm $VIRTUALBOX_FILE
fi

# Test if vagrant is installed
command -v vagrant >/dev/null 2>&1
INSTALLED=$?
echo ""

INSTALL_VAGRANT=''
REQUIRED_VAGRANT_VERSION=1.4.3

# https://github.com/noitcudni/vagrant-ae

if [ $INSTALLED == 0 ] ; then
    echo "Vagrant is installed"
    VERSION_VAGRANT=`vagrant -v | awk '{ print $2 }'`

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
                    sudo rm -rf /opt/vagrant
                    sudo rm /usr/bin/vagrant
                    
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
    VAGRANT_FILE="$HOME/Downloads/Vagrant-$REQUIRED_VAGRANT_VERSION.rpm"
    if [ ! -d "$VAGRANT_FILE" ] ; then
        curl -Lk http://966b.http.dal05.cdn.softlayer.net/data-production/96ce8e4c0efb26bf5e1e70afd0483e15b57e7202?filename=vagrant_1.4.3_x86_64.rpm -o $VAGRANT_FILE
    fi
    sudo rpm -i VAGRANT_FILE
    
    rm $VAGRANT_FILE
fi