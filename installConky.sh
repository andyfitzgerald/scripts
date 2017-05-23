#!/bin/bash

# Notes:
# You will also need to install several custom fonts:
# 1) copy into "/usr/local/share/fonts"
# 2) rebuild font cache: fc-cache -f -v

# Function to conditionally print to terminal
function log () {
        if [[ $_VERBOSE -eq 1 ]]; then
                if [ -n "$1" ]; then
                        IN="$@"
                else
                        # This reads a string from stdin and stores it in a variable called IN
                        while read INPUT; do
                                IN+="$INPUT\n"
                        done
                fi
                if [ ! -z "$IN" ]; then
                        echo -e "$IN"
                fi
        fi
        unset IN
}

# Verify that the required package has been installed
# Ref: http://stackoverflow.com/a/10439058
function getPackage () {
        local package="$1"
        if [ $(dpkg-query -W -f='${Status}' "$package" 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
                log "Package ${package} not installed. Installing it now."
                sudo apt-get --force-yes --yes install "${package}"
        fi
}

# Verify that the required package has been installed
function getPackages () {
        log "Verifying and installing these packages if needed: $@"
        for p in "$@"; do
                getPackage "$p"
        done
}

function getOsVers () {
        echo $(lsb_release -r | grep -oP "[0-9]+[.][0-9]+")
}


_VERBOSE=1

if [[ "$(getOsVers)" == "16.04" ]]; then
        getPackages "conky" "conky-all" "lua5.1" "hddtemp" "smartmontools" "thermald" "lm-sensors"
else
        log "Unrecognized OS version. Not installed pre-requisites."
fi

conky -c ~/.conky/.conkyDateTime &
conky -c ~/.conky/.conkySysStats &
conky -c ~/.conky/.conkyFortune &
