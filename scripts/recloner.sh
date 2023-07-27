#!/bin/bash

# Get the current directory path
current_directory=$(pwd)

# Move up two levels to the parent directory
cd ..

# sudo isn't explicitly required here, but sometimes there are problems without sudo
sudo mv "$current_directory/Signal-Server/personal-config" ./

sudo rm -rf Signal-Server

git clone https://github.com/JJTofflemire/Signal-Server.git

sudo mv personal-config Signal-Server

cd Signal-Server