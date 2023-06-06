#!/bin/bash

sudo docker-compose down

sudo docker-compose up -d

java -jar -Dsecrets.bundle.filename=config-secrets-bundle.yml service/target/TextSecureServer-0.0.0-dirty-SNAPSHOT.jar server config.yml


