#!/bin/bash

cd .. && cd ..

mv Signal-Server/personal-config ./

rm -rf Signal-Server

git clone https://github.com/JJTofflemire/Signal-Server.git

cd Signal-Server