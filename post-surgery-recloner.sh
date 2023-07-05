#!/bin/bash

git reset --hard post-surgery

mvn clean install -DskipTests -Pexclude-spam-filter

read -p "Do you want to start Signal-Server? (Press Enter to continue type 'n' to exit): " choice

if [[ $choice == "n" ]]; then
  echo -e "\nExiting..."
else
  echo -e "\n"
  source quickstart.sh
fi