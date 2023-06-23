#!/bin/bash

# Find the JAR file matching the name pattern -ChatGPT
jar_file=$(find service/target -name "TextSecureServer*.jar" ! -name "*-tests.jar" | head -n 1)

# Check if a valid JAR file is found -ChatGPT
if [[ -n "$jar_file" && -f "$jar_file" ]]; then
  echo -e "\nStarting Signal-Server using $jar_file\n"

  # Export the environmental variables when starting the server instead of keeping them in .bashrc
  source secrets.sh

  # You may have to add or remove sudo here
  docker-compose up -d

  # Start the server with the selected JAR file and configuration
  java -jar -Dsecrets.bundle.filename=config-secrets-bundle.yml "$jar_file" server config.yml

else
  echo -e "\nNo valid Signal-Server JAR file found." # Else echo that the server couldn't be found -ChatGPT
  docker-compose down
fi

# Get the process ID (PID) of the Java process -ChatGPT
JAVA_PID=$!

# Wait for the Java process to exit -ChatGPT
while kill -0 $JAVA_PID > /dev/null 2>&1; do
    sleep 1
done

# Stop the server and clean up -ChatGPT
docker-compose down

echo -e "\nStopped $jar_file"

# The script above should always work, but in case it fails here is the bare-bones version:
#
#source secrets.sh
#sudo docker-compose down
#sudo docker-compose up -d
#java -jar -Dsecrets.bundle.filename=config-secrets-bundle.yml service/target/TextSecureServer-<VERSION>-<SNAPSHOT/dirty>.jar server config.yml
