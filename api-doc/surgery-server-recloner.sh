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

cd Signal-Server

git checkout post-surgery

mvn clean install -DskipTests -Pexclude-spam-filter

cd ../

mv config.yml Signal-Server
mv config-secrets-bundle.yml Signal-Server
mv secrets.sh Signal-Server

mv Signal-Server/config-surgery.yml ./
mv Signal-Server/config-secrets-bundle-surgery.yml ./
mv ./ Signal-Server/data
mv ./ Signal-Server/redis_main
mv ./ Signal-Server/redis_replication

read -p "Do you want to start Signal-Server? (Press Enter to continue type 'n' to exit): " choice

if [[ $choice == "n" ]]; then
  echo "Exiting..."
else
  cd Signal-Server
  echo -e "\n"
  source surgerystart.sh
fi
