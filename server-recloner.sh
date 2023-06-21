#!/bin/bash
#
# What I use to reclone Signal-Server. It moves all personal config files to make recloning and running easier
# Put this file outside of your Signal-Server folder

mv Signal-Server/config.yml ./
mv Signal-Server/config-secrets-bundle.yml ./
mv Signal-Server/secrets.sh ./

sudo rm -r Signal-Server

git clone https://github.com/JJTofflemire/Signal-Server

cd Signal-Server

mvn clean install -DskipTests -Pexclude-spam-filter

cd ../

mv config.yml Signal-Server
mv config-secrets-bundle.yml Signal-Server
mv secrets.sh Signal-Server

read -p "Do you want to start Signal-Server? (Press Enter to continue type 'n' to exit): " choice

if [[ $choice == "n" ]]; then
  echo "Exiting..."
else
  cd Signal-Server
  echo -e "\n"
  source quickstart.sh
fi
