#!/bin/bash

# Script to set desktop background for students

# Author : Richard Purves <r.purves@arts.ac.uk>, Sean Hansell <sean@morelen.net>
# Version 1.0 : Initial Version
# Version 1.1 : 2014-04-23 - Massive reworking to use applescript for 10.8 and below, modify the db for 10.9+
# Version 1.2 : 2014-04-24 - Removed applescript because of osascript parsing issues. replaced with mcx.
# Version 1.3 : 2016-03-07 - Overhaul to variablize the desktop picture path.

desktop_picture="${4}"

os_version=$( sw_vers | grep ProductVersion: | awk '{print $2}' | sed 's/\./\ /g' | awk '{print $2}' )
current_user=$( ls -l /dev/console | awk '{print $3}' )
current_user_home=$( dscl . -read "/Users/${current_user}" NFSHomeDirectory | sed 's/NFSHomeDirectory\:\ //' )

if [[ -z "${desktop_picture}" ]]
then
	exit 1
fi

if (( $os_version > 8 ))
then
	sqlite3 "${current_user_home}/Library/Application Support/Dock/desktoppicture.db" << EOF
		UPDATE data SET value = "${desktop_picture}";
		.quit
	EOF
else
	defaults delete com.apple.desktop Background
	defaults write com.apple.desktop Background '{default = {ImageFilePath = "'"${desktop_picture}"'";};}'
fi

killall Dock

exit 0