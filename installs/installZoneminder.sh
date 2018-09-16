#!/bin/bash

scriptName="$(basename "$0")"
scriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
dateStamp=$(date --iso-8601="seconds")

source "${scriptDir}/../utils.sh"

# Relevant install steps copied from:
# https://zoneminder.readthedocs.io/en/stable/installationguide/debian.html#easy-way-debian-jessie
function installZoneMinder() {
  # Step 3: Install Apache and MySQL
  # These are not dependencies for the package as they could be installed elsewhere.
  apt-get install --yes apache2 mysql-server

  # Step 5: Install ZoneMinder
  apt-get update
  sudo apt-get install --yes zoneminder

  # Step 6: Read the Readme
  # The rest of the install process is covered in the README.Debian, so feel free to have a read.
  readme='/usr/share/doc/zoneminder/README.Debian'
  gunzip "${readme}.gz"
  echo "REMINDER: You should read the doc at \"${readme}\""

  # Step 7: Setup Database
  # Install the zm database and setup the user account. Refer to Hints in Ubuntu install should you choose to change default database user and password.
  cat /usr/share/zoneminder/db/zm_create.sql | sudo mysql --defaults-file=/etc/mysql/debian.cnf
  echo 'grant lock tables,alter,create,select,insert,update,delete,index on zm.* to 'zmuser'@localhost identified by "zmpass";'    | sudo mysql --defaults-file=/etc/mysql/debian.cnf mysql

  # Step 8: zm.conf Permissions
  # Adjust permissions to the zm.conf file to allow web account to access it.
  chgrp -c www-data /etc/zm/zm.conf

  # Step 9: Setup ZoneMinder service
  systemctl enable zoneminder.service

  # Step 10: Configure Apache
  # The following commands will setup the default /zm virtual directory and configure required apache modules.
  a2enconf zoneminder
  a2enmod cgi
  a2enmod rewrite

  # Step 11: Edit Timezone in PHP
  # Search for [Date] (Ctrl + w then type Date and press Enter) and change date.timezone for your time zone. Don’t forget to remove the ; from in front of date.timezone
  #nano /etc/php5/apache2/php.ini

  # Step 12: Start ZoneMinder
  # Reload Apache to enable your changes and then start ZoneMinder.
  systemctl reload apache2
  systemctl start zoneminder
}


_VERBOSE=1

if [[ "$(getOsVers)" == "16.04" ]]; then
  installZoneMinder
else
	echo "Unrecognized OS version. Not installed pre-requisites."
fi