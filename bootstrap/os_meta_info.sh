#!/bin/sh
#******************************************************************************************+
#        file: os_meta_info.sh                                                             #
#        purpose: Script to find out OS related meta information                           # 
#        USAGE: To test this script run as:                                                #
#               $ sh os_meta_info.sh test                                                  #
#        Author: Hikmat Dhamee                                                             #
#******************************************************************************************+

#Variable declaralation to hold OS meta data
OS_NAME=''
OS_DISTRO=''
OS_DISTRO_BASED_ON='' 
OS_PSUEDO_NAME=''
OS_REVISION=''
OS_KERNEL_VER=''
OS_ARCH=''

#Variable initialization
OS_NAME=`echo \`uname\` | tr A-Z a-z`
OS_KERNEL_VER=`uname -r`
OS_ARCH=`uname -m`

#Finding value of above variables based on os name
if [ "$OS_NAME" = "windowsnt" ]; then
    OS_NAME='Windows'
elif [ "$OS_NAME" = "darwin" ]; then
    OS_NAME='Darwin'
else    
    if [ "$OS_NAME" = "sunos" ] ; then
        OS_NAME='Solaris'
        OS_ARCH=`uname -p`
        OSSTR="$OS_NAME $OS_REVISION($OS_ARCH `uname -v`)"
    elif [ "$OS_NAME" = "aix" ] ; then
        OS_NAME='AIX'
        OSSTR="$OS_NAME `oslevel` (`oslevel -r`)"
    elif [ "$OS_NAME" = "linux" ] ; then
        OS_NAME='Linux'
        if [ -f /etc/redhat-release ] ; then
            OS_DISTRO_BASED_ON='RedHat'
            OS_DISTRO=`cat /etc/redhat-release |sed s/\ release.*//`
            OS_PSUEDO_NAME=`cat /etc/redhat-release | sed s/.*\(// | sed s/\)//`
            OS_REVISION=`cat /etc/redhat-release | sed s/.*release\ // | sed s/\ .*//`
        elif [ -f /etc/SuSE-release ] ; then
            OS_DISTRO_BASED_ON='SuSe'
            OS_PSUEDO_NAME=`cat /etc/SuSE-release | tr "\n" ' '| sed s/VERSION.*//`
            OS_REVISION=`cat /etc/SuSE-release | tr "\n" ' ' | sed s/.*=\ //`
        elif [ -f /etc/mandrake-release ] ; then
            OS_DISTRO_BASED_ON='Mandrake'
            OS_PSUEDO_NAME=`cat /etc/mandrake-release | sed s/.*\(// | sed s/\)//`
            OS_REVISION=`cat /etc/mandrake-release | sed s/.*release\ // | sed s/\ .*//`
        elif [ -f /etc/debian_version ] ; then
            # In case of Debian/Ubuntu sometime by default /bin/sh points to dash which should be made to point bash
            sudo ln -sf bash /bin/sh
            OS_DISTRO_BASED_ON='Debian'
            OS_DISTRO=`cat /etc/lsb-release | grep '^DISTRIB_ID' | awk -F=  '{ print $2 }'`
            OS_PSUEDO_NAME=`cat /etc/lsb-release | grep '^DISTRIB_CODENAME' | awk -F=  '{ print $2 }'`
            OS_REVISION=`cat /etc/lsb-release | grep '^DISTRIB_RELEASE' | awk -F=  '{ print $2 }'`
            
        fi
        if [ -f /etc/UnitedLinux-release ] ; then
            OS_DISTRO="$OS_DISTRO[`cat /etc/UnitedLinux-release | tr "\n" ' ' | sed s/VERSION.*//`]"
        fi

        #OS_NAME=`echo $OS_NAME |tr A-Z a-z`
        #OS_DISTRO_BASED_ON=`echo $OS_DISTRO_BASED_ON |tr A-Z a-z`

        readonly OS_NAME
        readonly OS_DISTRO
        readonly OS_DISTRO_BASED_ON
        readonly OS_PSUEDO_NAME
        readonly OS_REVISION
        readonly OS_KERNEL_VER
        readonly OS_ARCH
    fi

fi

#Prints the OS meta information to stdout
test(){
    echo "==========================================="
    echo
    echo  "OS_NAME: $OS_NAME"
    echo
    echo  "OS_DISTRO: $OS_DISTRO"
    echo
    echo  "OS_DISTRO_BASED_ON: $OS_DISTRO_BASED_ON"
    echo
    echo  "OS_PSUEDO_NAME: $OS_PSUEDO_NAME"
    echo
    echo  "OS_REVISION: $OS_REVISION"
    echo
    echo  "OS_KERNEL_VER: $OS_KERNEL_VER"
    echo
    echo  "OS_ARCH: $OS_ARCH"
    echo
    echo "==========================================="
}

########### tests this script
if [ $# -ne 0 ] && [ "$1" = "test" ] && [ $(basename $0) = "os_meta_info.sh" ];
 then
    test
    exit
else if [ $(basename $0) = "os_meta_info.sh" ]; then
        echo "For Testing-----USAGE: $(basename $0) test"
     fi   
fi