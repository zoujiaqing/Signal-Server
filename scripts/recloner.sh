#!/bin/bash

# Move up two levels to the parent directory
cd ..

# Get the current directory path
folder=$(pwd)

cd ..

# sudo isn't explicitly required here, but sometimes there are problems without sudo
sudo mv "$folder/personal-config" ./

sudo rm -rf "$folder"

git clone https://github.com/JJTofflemire/Signal-Server.git

sudo mv Signal-Server "$folder"

sudo rm -rf "$folder"/personal-config

sudo mv personal-config "$folder"

cd "$folder"