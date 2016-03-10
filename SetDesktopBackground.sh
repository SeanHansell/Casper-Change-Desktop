#!/bin/bash

# Script to set desktop background via Casper. Forked from the original work of Richard Purves <richard@richard-purves.com>.

# Maintainer : Sean Hansell <sean@morelen.net>
# Version 1.0 : Initial Version
# Version 1.1 : 2014-04-23 - Massive reworking to use Applescript for 10.8 and below or modify the sqlite DB for 10.9+
# Version 1.2 : 2014-04-24 - Removed AppleScript because of osascript parsing issues. Replaced with MCX.
# Version 1.3 : 2016-03-07 - Overhaul to variablize the desktop picture path.
#       1.3.1 : 2016-03-07 - Added root check to catch situations where the login window is up.

# Casper Static Variables
desktop_picture="${4}" # Path to Desktop Picture. Define this in Casper.

# Dynamic Variables
os_version=$( sw_vers | grep ProductVersion: | awk '{print $2}' | sed 's/\./\ /g' | awk '{print $2}' )
current_user=$( ls -l /dev/console | awk '{print $3}' )
current_user_home=$( dscl . -read "/Users/${current_user}" NFSHomeDirectory | sed 's/NFSHomeDirectory\:\ //' )
desktop_db="${current_user_home}/Library/Application Support/Dock/desktoppicture.db"
desktop_domain="${current_user_home}/Library/Preferences/com.apple.desktop"
desktop_plist="${desktop_domain}.plist"

if [[ -z "${desktop_picture}" ]]
then
	echo "desktop_picture variable is empty. Nothing to do."
	exit 1
fi

if [[ "${current_user}" == "root" ]]
then
	echo "No user logged in. Nothing to do."
	exit 0
fi

if (( $os_version > 8 ))
then
	sqlite3 "${desktop_db}" << EOF
UPDATE data SET value = "${desktop_picture}";
.quit
EOF
else
	defaults delete "${desktop_domain}" Background
	defaults write "${desktop_domain}" Background '{default = {ImageFilePath = "'"${desktop_picture}"'";};}'
	chown "${current_user}" "${desktop_plist}" # Previous commands change ownership to root. Maintaining ownership.
fi

killall Dock

echo "Desktop picture changed to ${desktop_picture}"
exit 0