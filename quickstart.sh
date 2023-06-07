#!/bin/bash

# You may have to add or remove sudo to these commands depending on how you have configured Docker
docker-compose down

docker-compose up -d

java -jar -Dsecrets.bundle.filename=config-secrets-bundle.yml service/target/TextSecureServer-0.0.0-SNAPSHOT.jar server config.yml
