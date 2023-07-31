#!/bin/bash

cd ..

# get only the name of the working directory in lower case to ensure that the correct volumes are deleted
folder=$(basename "$(pwd)" | tr '[:upper:]' '[:lower:]')

sudo docker volume rm -f "$folder"_redis-cluster_data-0
sudo docker volume rm -f "$folder"_redis-cluster_data-1
sudo docker volume rm -f "$folder"_redis-cluster_data-2
sudo docker volume rm -f "$folder"_redis-cluster_data-3
sudo docker volume rm -f "$folder"_redis-cluster_data-4
sudo docker volume rm -f "$folder"_redis-cluster_data-5

sudo docker-compose -f docker-compose-first-run.yml up -d && sudo docker-compose -f docker-compose-first-run.yml down