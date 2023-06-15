#!/bin/bash

# I export the environmental variables when I start the server instead of keeping them in .bashrc (mostly so I can put my .bashrc on Github because I tend to forget or lose it)
source secrets.sh

# You may have to add or remove sudo to these commands depending on how you have configured Docker
sudo docker-compose down

sudo docker-compose up -d

# Make sure this calls the right config files and the right server
java -jar -Dsecrets.bundle.filename=config-secrets-bundle.yml service/target/TextSecureServer-0.0.0-SNAPSHOT.jar server config.yml
