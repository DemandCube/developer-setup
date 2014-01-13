#!/bin/sh

# http://stackoverflow.com/questions/6682335/how-can-check-if-particular-application-software-is-installed-in-mac-os
# whichapp com.apple.finder # -> '/System/Library/CoreServices/Finder.app'
# whichapp Finder # -> '/System/Library/CoreServices/Finder.app'

whichapp() {

    # Command-line help.
    if [[ "$1" == '--help' || "$1" == '-h' ]]; then
        cat <<EOF
Synopsis:
    $FUNCNAME appNameOrBundleId
    $FUNCNAME -l

Description:
    Like \`which\`, except for applications (*.app bundles).

    Synopsis form 1:
        Returns the full path of the specified application 'file'
        (i.e., the bundle folder).

        You can either specify an application name (e.g., 'Finder' or 'Finder.app')
        or a bundle ID (e.g. 'com.apple.Finder').
        In either event name matching is case-INsensitive.
        If you're specifying a name that happens to contain periods, 
        append '.app' to disambiguate it from a bundle ID.

        If the application is not found, an error is reported and the exit code is set to 1.

    Synopsis form 2:
        When -l is specified, a list of the *names* of all installed applications is printed.

    CAVEATS: 
        - SLOW, especially if you search by application *name* or use \`-l\`, because
          system_profiler is used to obtain the list of installed applications.

Examples:
    $FUNCNAME Finder
    $FUNCNAME Mail.app
    $FUNCNAME com.apple.finder
EOF
        return 0
    fi

    # Option-parameters loop.
    local listApps=0
    while (( $# )); do
        case "$1" in
            -l)
                listApps=1
                ;;
            --) # Explicit end-of-options marker.
                shift   # Move to next param and proceed with data-parameter analysis below.
                break
                ;;
            -*) # An unrecognized switch.
                echo -e "$FUNCNAME: PARAMETER ERROR: Unrecognized option: '$1'. To force interpretation as non-option, precede with --.\nUse -h or --h to get help." 1>&2 && return 2
                ;;
            *)  # 1st data parameter reached; proceed with data-parameter analysis below.
                break
                ;;
        esac
        shift
    done

    if (( ! listApps )); then
        # Make sure we have at least one data parameter.
        [[ -z "$1" ]] && echo -e "$FUNCNAME: PARAMETER ERROR: Too few parameters specified. Use -h or --h to get help." 1>&2 && return 2
        local appNameOrBundleId="$1"; shift
    fi

    # Make sure that not too many parameters were specified.
    (( $# )) && echo -e "$FUNCNAME: PARAMETER ERROR: Unexpected parameter(s) specified. Use -h or --h to get help." 1>&2 && return 2

    local ec=0
    if (( listApps )); then
            # Get info about all applications; we HAVE to use a temp. file, unfortunately, because PlistBuddy expects a file and sadly won't work with process substitution.
        local ftemp=$(mktemp -t '$FUNCNAME')
        system_profiler -xml SPApplicationsDataType > "$ftemp"
            # Print all application names.
        /usr/libexec/PlistBuddy -c "print :0:_items:" "$ftemp" | awk -F [=] '/^[[:space:]]+_name = / { print substr($2, 2) }'        
        ec=$?
        rm "$ftemp"
    else
        # Determine if an application name or a bundle ID was specified.
        local isAppName=0
        local searchTokenType='bundle ID'
        [[ "$appNameOrBundleId" =~ \.app$ || "$appNameOrBundleId" =~ ^[^.]+$ ]] && { isAppName=1; searchTokenType='name'; }

        local appBundlePath=''
        if (( isAppName )); then # application name
            # !! `POSIX path of (path to application "'"$appNameOrBundleId"'")` is NOT an option, because it implicitly
            # !! LAUNCHES the application in question.
            # !! Using system_profiler is slow, unfortunately, but exhaustive - presumably it queries LaunchServices - better than we could ever do guessing all locations.
                # Get info about , unfortunately, because PlistBuddy expects a file and sadly won't work with process substitution.
            local ftemp=$(mktemp -t '$FUNCNAME')
            system_profiler -xml SPApplicationsDataType > "$ftemp"
            local appNameLCase=$(tr [:upper:] [:lower:] <<<"${appNameOrBundleId%.app}")
            appBundlePath=$(/usr/libexec/PlistBuddy -c "print :0:_items:" "$ftemp" | awk -F [=] 'tolower($0) ~ /^[[:space:]]+_name = '"$appNameLCase"'$/,/^[[:space:]]+path = / { if (appName == "") { appName=substr($2, 2) } else { appPath=substr($2, 2) } } END { print appPath }')
            ec=$?
            rm "$ftemp"
        else # bundle ID
            # Use AppleScript to find the path. Fortunately, this approach does NOT implicitly start the application.
            # !! The Finder context IS needed, as using "application id ..." directly indeed also launches the application.
            appBundlePath=$(osascript -e 'try' -e 'tell application "Finder" to return POSIX path of (application file id "'"$appNameOrBundleId"'" as text)' -e 'end try' 2>/dev/null)
            # osascript -e 'try' -e 'tell application "Finder" to return POSIX path of (application file id "'"org.virtualbox.app.VirtualBox"'" as text)' -e 'end try'
        fi

        if [[ -n "$appBundlePath" ]]; then
            echo "$appBundlePath"
        else
            echo "ERROR: Cannot find application with $searchTokenType '$appNameOrBundleId'." 1>&2
            ec=1
        fi
    fi

    return $ec
}

whichapp $1