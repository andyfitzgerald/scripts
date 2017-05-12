#!/bin/bash

source utils.sh

_VERBOSE=1

if [[ "$(getOsVers)" == "16.04" ]]; then
	getPackages "docx2txt" "catdoc" "odt2txt" "pdf2txt" "python-excelerator" "xlsx2csv"
else
	echo "Unrecognized OS version. Not installed pre-requisites."
fi
