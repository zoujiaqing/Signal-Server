#!/bin/bash

cd ..

# sudo isn't explicitly required here, but sometimes there are problems without sudo
sudo cp scripts/intact/WhisperServerService.java service/src/main/java/org/whispersystems/textsecuregcm

source mvnw clean install -DskipTests -Pexclude-spam-filter

read -p "Do you want to start Signal-Server? (Press Enter to continue type 'n' to exit): " choice

if [[ $choice == "n" ]]; then
  echo -e "\nExiting..."
else
  echo -e "\n"
  cd scripts
  source quickstart.sh
fi