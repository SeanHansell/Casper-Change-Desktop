#!/bin/bash

# Script to set desktop background for students

# Author : r.purves@arts.ac.uk
# Version 1.0 : Initial Version
# Version 1.1 : 23/04/2014 - Massive reworking to use applescript for 10.8 and below, modify the db for 10.9+
# Version 1.2 : 24/04/2014 - Removed applescript because of osascript parsing issues. replaced with mcx.


os_version=$( sw_vers | grep ProductVersion: | awk '{print $2}' | sed 's/\./\ /g' | awk '{print $2}' )
current_user=$( ls -l /dev/console | awk '{print $3}' )
current_user_home=$( dscl . -read /Users/sean NFSHomeDirectory | sed 's/NFSHomeDirectory\:\ //' )

if [[ "$4" = "custom" ]]
then
	if (( $os_version > 8 ))
	then
		sqlite3 "/Users/${current_user_home}/Library/Application Support/Dock/desktoppicture.db" << EOF
			UPDATE data SET value = "/Users/Shared/Background/custombg.jpeg";
			.quit
			EOF
		killall Dock
	else
		defaults write com.apple.desktop Background '{default = {ImageFilePath = "/Users/Shared/Background/custombg.jpeg"; };}'
		killall Dock
	fi
else
	if (( $os_version > 8 ))
	then
		sqlite3 "/Users/${current_user_home}/Library/Application Support/Dock/desktoppicture.db" << EOF
			UPDATE data SET value = "/Library/Desktop Pictures/default_grey2560x1600.jpeg";
			.quit
			EOF
		killall Dock
	else
		defaults write com.apple.desktop Background '{default = {ImageFilePath = "/Library/Desktop Pictures/default_grey2560x1600.jpeg"; };}'
		killall Dock
	fi
fi

exit 0