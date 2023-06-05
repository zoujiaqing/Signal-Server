#!/bin/bash

sudo rm -r Signal-Server

git clone https://github.com/signalapp/Signal-Server.git && cd Signal-Server && git checkout e6917d8

mvn clean install -DskipTests -Pexclude-spam-filter

cd ~/Desktop

sudo docker-compose up -d

java -jar -Dsecrets.bundle.filename=sample-secrets-bundle.yml Signal-Server/service/target/TextSecureServer-9.80.0.jar server sample.yml


