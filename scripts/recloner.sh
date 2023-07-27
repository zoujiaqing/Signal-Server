#!/bin/bash

# Move up two levels to the parent directory
cd ..

# Get the current directory path
current_directory=$(pwd)

cd ..

# sudo isn't explicitly required here, but sometimes there are problems without sudo
sudo mv "$current_directory/personal-config" ./

sudo rm -rf "$current_directory"

git clone https://github.com/JJTofflemire/Signal-Server.git

sudo mv Signal-Server "$current_directory"

sudo rm -rf "$current_directory"/personal-config

sudo mv personal-config "$current_directory"

cd "$current_directory"