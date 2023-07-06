#!/bin/bash

cd .. && cd ..

# sudo isn't explicitly required here, but sometimes there are problems without sudo
sudo mv Signal-Server/personal-config ./

rm -rf Signal-Server

git clone https://github.com/JJTofflemire/Signal-Server.git

mv personal-config Signal-Server

cd Signal-Server