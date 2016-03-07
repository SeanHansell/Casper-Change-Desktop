Set Desktop Background
----------------------

This script checks parameter 4 being passed from Casper. If it's set to the valid path of a file you want to act as your desktop background, you get the desktop background. Otherwise, nothing happens.

10.8 or lower, we use a `/usr/bin/defaults` call to make the wallpaper change running as current logged in user.
10.9 or higher, we're directly manipulating the desktoppicture.db database.