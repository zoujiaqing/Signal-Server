#!/bin/bash

mv Signal-Server/config.yml ./
mv Signal-Server/config-secrets-bundle.yml ./
mv Signal-Server/secrets.sh ./

mv Signal-Server/config-surgery.yml ./
mv Signal-Server/config-secrets-bundle-surgery.yml ./
mv Signal-Server/data ./
mv Signal-Server/redis_main ./
mv Signal-Server/redis_replication ./

sudo rm -r Signal-Server

git clone https://github.com/JJTofflemire/Signal-Server

mv config.yml Signal-Server
mv config-secrets-bundle.yml Signal-Server
mv secrets.sh Signal-Server

mv ./config-surgery.yml Signal-Server
mv ./config-secrets-bundle-surgery.yml Signal-Server
mv ./data Signal-Server
mv ./redis_main Signal-Server
mv ./redis_replication Signal-Server

cd Signal-Server

mvn clean install -DskipTests -Pexclude-spam-filter

read -p "Do you want to start Signal-Server? (Press Enter to continue type 'n' to exit): " choice

if [[ $choice == "n" ]]; then
  echo -e "\nExiting..."
else
  echo -e "\n"
  source quickstart.sh
fi
