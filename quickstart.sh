#!/bin/bash

# Find the JAR file matching the name pattern -ChatGPT
jar_file=$(find service/target -name "TextSecureServer*.jar" ! -name "*-tests.jar" | head -n 1)

# Check if a valid JAR file is found -ChatGPT
if [[ -n "$jar_file" && -f "$jar_file" ]]; then
  echo "Starting Signal-Server using $jar_file"

  # Export the environmental variables when starting the server instead of keeping them in .bashrc
  source secrets.sh

  # You may have to add or remove sudo to these commands depending on how you have configured Docker
  sudo docker-compose down
  sudo docker-compose up -d

  # Start the server with the selected JAR file and configuration
  java -jar -Dsecrets.bundle.filename=config-secrets-bundle.yml "$jar_file" server config.yml

else
  echo "No valid Signal-Server JAR file found." # Else echo that the server couldn't be found -ChatGPT
fi

# The script above should always work, but in case it fails here is the bare-bones version:
#
#source secrets.sh
#sudo docker-compose down
#sudo docker-compose up -d
#java -jar -Dsecrets.bundle.filename=config-secrets-bundle.yml service/target/TextSecureServer-<VERSION>-<SNAPSHOT/dirty>.jar server config.yml