#!/bin/bash

cd redis-cluster
sudo docker-compose up -d
cd ../registration-service
sudo docker-compose up -d

cd ..
./personal-config/secrets.sh

sleep 5

java -jar -Dsecrets.bundle.filename=personal-config/config-secrets-bundle.yml Signal-Server.jar server personal-config/config.yml | awk '{
      gsub(/WARN /, "\033[33m&\033[0m");
      gsub(/ERROR/, "\033[31m&\033[0m");
      gsub(/INFO/, "\033[32m&\033[0m");
  }
  /Timing: [0-9]+ ms/,/<\/html>/ {next}
  !/^\s*$/ {
     print
  }'

JAVA_PID=$!
while kill -0 $JAVA_PID > /dev/null 2>&1; do
    sleep 1
done

read -p "Do you want to stop docker-compose.yml? (Press Enter to continue type 'n' to exit): " choice

if [[ $choice == "n" ]]; then
  echo -e "\nExiting..."
else
	cd redis-cluster
	sudo docker-compose down
	cd ../registration-service
	sudo docker-compose down
 	echo -e "\nStopped docker-compose dependencies"
fi
