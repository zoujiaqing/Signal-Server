#!/bin/bash

cd ..

git reset --hard main

cp recloner-scripts/intact/WhisperServerService.java service/src/main/java/org/whispersystems/textsecuregcm

mvn clean install -DskipTests -Pexclude-spam-filter

read -p "Do you want to start Signal-Server? (Press Enter to continue type 'n' to exit): " choice

if [[ $choice == "n" ]]; then
  echo -e "\nExiting..."
else
  echo -e "\n"
  source quickstart.sh
fi