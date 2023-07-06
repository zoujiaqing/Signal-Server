#!/bin/bash

# Find the JAR file matching the name pattern -ChatGPT
jar_file=$(find service/target -name "TextSecureServer*.jar" ! -name "*-tests.jar" | head -n 1)

# Check if a valid JAR file is found -ChatGPT
if [[ -n "$jar_file" && -f "$jar_file" ]]; then
  echo -e "\nStarting Signal-Server using $jar_file\n"

  # Export the environmental variables when starting the server instead of keeping them in .bashrc
  source personal-config/secrets.sh

  # You may have to add or remove sudo here
  docker-compose up -d

  # Sleep for 2 seconds so that the cluster will be reachable by the time Signal-Server attempts to connect
  sleep 4

  # Start the server with the selected JAR file and configuration
  java -jar -Dsecrets.bundle.filename=personal-config/config-secrets-bundle.yml "$jar_file" server personal-config/config.yml

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

echo -e "\nStopped $jar_file\n"

read -p "Do you want to stop docker-compose? (Press Enter to continue type 'n' to exit): " choice

if [[ $choice == "n" ]]; then
  echo -e "\nExiting..."
else
  # Stop the server and clean up -ChatGPT
  docker-compose down

  echo -e "\nStopped docker-compose dependancies"
fi
