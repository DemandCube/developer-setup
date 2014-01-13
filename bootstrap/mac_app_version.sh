#!/bin/sh

# whichversion com.apple.finder # -> ''
# whichversion Finder # -> ''

whichversion() {

    # Command-line help.
    if [[ "$1" == '--help' || "$1" == '-h' ]]; then
        cat <<EOF
Synopsis:
    $FUNCNAME appNameOrBundleId

Description:
    Finds version of an application (*.app bundles).

    Returns the full path of the specified application 'file'
    (i.e., the bundle folder).

    You can either specify an application name (e.g., 'Finder' or 'Finder.app')
    or a bundle ID (e.g. 'com.apple.Finder').
    In either event name matching is case-INsensitive.
    If you're specifying a name that happens to contain periods, 
    append '.app' to disambiguate it from a bundle ID.

    If the application version is not found, an error is reported and the exit code is set to 1.

Examples:
    $FUNCNAME Finder
    $FUNCNAME Mail.app
    $FUNCNAME com.apple.finder
EOF
        return 0
    fi

    # Option-parameters loop.
    while (( $# )); do
        case "$1" in
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


    # Make sure we have at least one data parameter.
    [[ -z "$1" ]] && echo -e "$FUNCNAME: PARAMETER ERROR: Too few parameters specified. Use -h or --h to get help." 1>&2 && return 2
    local appNameOrBundleId="$1"; shift

    # Make sure that not too many parameters were specified.
    (( $# )) && echo -e "$FUNCNAME: PARAMETER ERROR: Unexpected parameter(s) specified. Use -h or --h to get help." 1>&2 && return 2

    local ec=0

    # Determine if an application name or a bundle ID was specified.
    local isAppName=0
    local searchTokenType='bundle ID'
    [[ "$appNameOrBundleId" =~ \.app$ || "$appNameOrBundleId" =~ ^[^.]+$ ]] && { isAppName=1; searchTokenType='name'; }

    # osascript -e 'try' -e 'get version of application "VirtualBox"' -e 'end try'
    # osascript -e 'try' -e 'get version of application id "org.virtualbox.app.VirtualBox"' -e 'end try'
    # osascript -e 'try' -e 'get id of application "VirtualBox"' -e 'end try'
    
    # Alternative search for the CFBundleVersion in the plist file
    # /usr/libexec/PlistBuddy -c "print :CFBundleVersion" "$appBundlePath/Contents/Info.plist"

    local appVersion=''
    if (( isAppName )); then # application name
        local appNameLCase=$(tr [:upper:] [:lower:] <<<"${appNameOrBundleId%.app}")
        appVersion=$(osascript -e 'try' -e 'get version of application "'"$appNameLCase"'"' -e 'end try' 2>/dev/null)
        ec=$?
    else # bundle ID
        # Use AppleScript to find the path. Fortunately, this approach does NOT implicitly start the application.
        # !! The Finder context IS needed, as using "application id ..." directly indeed also launches the application.
        appVersion=$(osascript -e 'try' -e 'get version of application id "'"$appNameOrBundleId"'"' -e 'end try' 2>/dev/null)
    fi

    if [[ -n "$appVersion" ]]; then
        echo "$appVersion"
    else
        echo "ERROR: Cannot find application with $searchTokenType '$appNameOrBundleId'." 1>&2
        ec=1
    fi

    return $ec
}

whichversion $1