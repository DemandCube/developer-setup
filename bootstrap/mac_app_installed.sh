#!/bin/bash

# http://stackoverflow.com/questions/6682335/how-can-check-if-particular-application-software-is-installed-in-mac-os
# ./mac_app_installed.sh com.apple.preview
# ./mac_app_installed.sh org.virtualbox.app.VirtualBo ; echo $? # 0
# ./mac_app_installed.sh org.virtualbox.app.VirtualBox ; echo $? # 1

# Return 0 -> Not Installed
# Return 1 -> Installed

APPLESCRIPT=`cat <<EOF
on run argv
  try
    tell application "Finder"
      set appname to name of application file id "$1"
      return 1
    end tell
  on error err_msg number err_num
    return 0
  end try
end run
EOF`

retcode=`osascript -e "$APPLESCRIPT" 2>/dev/null`
exit $retcode