#!/bin/sh

# http://stackoverflow.com/questions/6682335/how-can-check-if-particular-application-software-is-installed-in-mac-os
# bundleid Finder # -> 'com.apple.finder'
# ./mac_app_bundleid VirtualBox

bundleid() {

    # Command-line help.
    if [[ "$1" == '--help' || "$1" == '-h' ]]; then
        cat <<EOF
Synopsis:
    $FUNCNAME appName

Description:
    Returns the bundle ID of an application specified by name.
    Application-name matching is case-INsensitive.

    CAVEAT: Slooow, due to use of system_profiler for obtaining the list of installed applications.

Examples:
    $FUNCNAME Reminders # -> 'com.apple.reminders' 
EOF
        return 0
    fi

    # Make sure we have at least one data parameter.
    [[ -z "$1" ]] && echo -e "$FUNCNAME: PARAMETER ERROR: Too few parameters specified. Use -h or --h to get help." 1>&2 && return 2

    local appName="$1"; shift

    # Make sure that not too many parameters were specified.
    (( $# )) && echo -e "$FUNCNAME: PARAMETER ERROR: Unexpected parameter(s) specified. Use -h or --h to get help." 1>&2 && return 2

    local appNameLCase=$(tr [:upper:] [:lower:] <<< "${appName%.app}")
    
    # !! `POSIX path of (path to application "'"$appName"'")` is NOT an option, because it implicitly
    # !! LAUNCHES the application in question.
    # !! Using system_profiler is slow, unfortunately, but exhaustive - presumably queries LaunchServices - better than we could ever do guessing all locations.
        # Get info about , unfortunately, because PlistBuddy expects a file and sadly won't work with process substitution.

    # Old way switch to simpler code
    # local ftemp=$(mktemp -t '$FUNCNAME')
    # system_profiler -xml SPApplicationsDataType > "$ftemp"
    # 
    # local appBundlePath=''
    # appBundlePath=$(/usr/libexec/PlistBuddy -c "print :0:_items:" "$ftemp" | awk -F [=] 'tolower($0) ~ /^[[:space:]]+_name = '"$appNameLCase"'$/,/^[[:space:]]+path = / { if (appName == "") { appName=substr($2, 2) } else { appPath=substr($2, 2) } } END { print appPath }')
    # rm "$ftemp"
    # 
    # # Abort, if the application wasn't found.
    # [[ -z "$appBundlePath" ]] && { echo "ERROR: Cannot locate application '$appName'." 1>&2; return 1; }
    # 
    # # Print the bundle ID by extracting it from the application bundle's /Contents/Info.plist property list.
    # /usr/libexec/PlistBuddy -c "print :CFBundleIdentifier" "$appBundlePath/Contents/Info.plist"
    
    local appBundleId=''
    appBundleId=$(osascript -e 'try' -e 'get id of application "'"$appNameLCase"'"' -e 'end try' 2>/dev/null)
    
    local ec=0
    if [[ -n "$appBundleId" ]]; then
        echo "$appBundleId"
    else
        echo "ERROR: Cannot find bundleid of application with '$appName'." 1>&2
        ec=1
    fi

    return $ec
}

bundleid $1