#!/bin/bash

cd ..

# Check if 'runtime.sh' has already been ran and try to prevent mistakes
if [ -e "runtime/Signal-Server.jar" ]; then
    read -p "It looks like you already ran 'runtime.sh'! Do you want to remove the contents of 'runtime' and re-create 'runtime'? (Press Enter to stop type 'n' to continue): " choice

    if [[ $choice == "n" ]]; then
        echo -e "okie dokie!\n"
    else
        echo -e "Don't worry, I made a backup anyways!\n"
        sudo cp -r runtime runtime-backup
        sudo rm -rf Signal-Server.jar server-certificates.md personal-config registration-service redis-cluster

        cd runtime/redis-cluster

        sudo docker volume rm -f redis-cluster_redis-cluster_data-0
        sudo docker volume rm -f redis-cluster_redis-cluster_data-1
        sudo docker volume rm -f redis-cluster_redis-cluster_data-2
        sudo docker volume rm -f redis-cluster_redis-cluster_data-3
        sudo docker volume rm -f redis-cluster_redis-cluster_data-4
        sudo docker volume rm -f redis-cluster_redis-cluster_data-5

        cd ../..
    fi
fi

# Choose to include or remove 'zkgroup'
read -p "Do you want to remove 'zkgroup' dependencies? (Press Enter to continue type 'n' to skip): " choice

if [[ $choice == "n" ]]; then
    sudo cp scripts/intact/WhisperServerService.java service/src/main/java/org/whispersystems/textsecuregcm
else
    sudo cp scripts/post-surgery/WhisperServerService.java service/src/main/java/org/whispersystems/textsecuregcm
fi

# Compile
./mvnw clean install -DskipTests -Pexclude-spam-filter

# Find the compiled server.jar and move files into 'runtime'
jar_file=$(find service/target -name "TextSecureServer*.jar" ! -name "*-tests.jar" | head -n 1)
sudo cp "$jar_file" runtime/Signal-Server.jar
sudo cp -r personal-config runtime/

cd runtime

# Download the latest Signal-Docker.zip and grab 'registration-service' and `redis-cluster`
wget -q https://github.com/JJTofflemire/Signal-Docker/archive/refs/heads/main.zip
jar xf main.zip
sudo cp -r Signal-Docker-main/registration-service registration-service
sudo cp -r Signal-Docker-main/redis-cluster redis-cluster
sudo rm -rf main.zip Signal-Docker-main

# Generate 'UnidentifiedDelivery' values and place them in server-certificates.md
java -jar -Dsecrets.bundle.filename=personal-config/config-secrets-bundle.yml \
    Signal-Server.jar certificate -ca | tee >(grep -oP '(?<=Private key: ).*' > private_key.txt) | \
    grep -oP '(?<=Public key : ).*' > public_key.txt
java -jar -Dsecrets.bundle.filename=personal-config/config-secrets-bundle.yml \
    Signal-Server.jar certificate --key "$(cat private_key.txt)" --id 123456 > certificate_output.txt

echo "# Command Outputs" >> server-certificates.md
echo -e "\n## First Command Output" >> server-certificates.md
cat public_key.txt >> server-certificates.md
echo -e "\n## Second Command Output" >> server-certificates.md
cat private_key.txt >> server-certificates.md
echo "" >> server-certificates.md
cat certificate_output.txt >> server-certificates.md
echo -e "\n --id 123456" >> server-certificates.md

rm certificate_output.txt private_key.txt public_key.txt

# Set up redis-cluster
cd redis-cluster
sudo wget -O docker-compose-first-run.yml https://raw.githubusercontent.com/bitnami/containers/fd15f56824528476ca6bd922d3f7ae8673f1cddd/bitnami/redis-cluster/7.0/debian-11/docker-compose.yml
sudo docker-compose -f docker-compose-first-run.yml up -d && sudo docker-compose -f docker-compose-first-run.yml down
sudo rm docker-compose-first-run.yml
cd ..

# Build 'registration-service' if the image doesn't already exist 
if ! sudo docker image ls | grep -q "registration-service"; then
    cd registration-service
    sudo docker build -t registration-service:1.0 .
    cd ..
else
    echo "'registration-service' found. Skipping building..."
fi

echo -e "\nFinished! Check out 'runtime/README.md' for what to do next"