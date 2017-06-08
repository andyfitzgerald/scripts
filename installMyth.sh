#!/bin/bash

source utils.sh

# Install MythTv using Mythbuntu PPA
# Installs:
# * Complete frontend and backend system with database
# * Plugins for a frontend system
# ...
# To-do: https://www.mythtv.org/wiki/Installing_MythTV_on_Ubuntu
function installMythtv () {
	sudo add-apt-repository --yes ppa:mythbuntu/0.28
	sudo apt-get update
	getPackages "mythtv" "mythplugins"

	# Database Configuration
	cp /etc/mythtv/mysql.txt "$HOME/.mythtv/"
}


_VERBOSE=1

if [[ "$(getOsVers)" == "16.04" ]]; then
	installMythtv
else
	echo "Unrecognized OS version. Not installed pre-requisites."
fi
