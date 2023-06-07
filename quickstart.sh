#!/bin/bash

# You may have to add or remove sudo to these commands depending on how you have configured Docker
docker-compose down

docker-compose up -d

# Make sure this calls the right config files and the right server
java -jar -Dsecrets.bundle.filename=config-secrets-bundle.yml service/target/TextSecureServer-0.0.0-SNAPSHOT.jar server config.yml
