#!/bin/bash

mvn clean install -DskipTests -Pexclude-spam-filter

sudo docker-compose up -d

java -jar -Dsecrets.bundle.filename=sample-secrets-bundle.yml Signal-Server/service/target/TextSecureServer-9.80.0.jar server sample.yml


