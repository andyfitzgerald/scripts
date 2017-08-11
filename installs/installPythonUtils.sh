#!/bin/bash

source utils.sh

_VERBOSE=1

if [[ "$(getOsVers)" == "16.04" ]]; then
	# python2
	getPackages "python-pip" "ipython" "python-dateutil"
	getPythonPackages "money" "Babel" "bs4" "lxml" "requests" "enum34" "beautifulsoup4"

	# python3
	getPackages "python3-pip" "ipython3" "python3-dateutil"
	getPythonPackages "pyoctopart" "dateutil" "money"
else
	echo "Unrecognized OS version. Not installed pre-requisites."
fi