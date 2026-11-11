#!/bin/bash
# save the scripts in /local/bin
# ------------------------------------
# sudo mv <script.sh> /usr/local/bin/
# sudo mv <script.sh> /usr/local/bin/update -> change the name of the file

release_file=/etc/os-release

# -q -> quiet mode, does not print to the screen
if grep -q "Arch" $release_file
then
    # The host is based on Arch, run the pacman update command
    sudo pacman -Syu
fi

if grep -q "Debian" $release_file || grep -q "Ubuntu" $release_file
then
    # The host is based on Ubuntu,
    # Run the apt version of the command
    sudo apt update
    sudo apt dist-upgrade
fi
