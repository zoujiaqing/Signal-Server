#!/bin/bash

cd ..

folder=$(basename $(pwd))

sudo docker volume rm -f "$folder"_redis-cluster-data-0
sudo docker volume rm -f "$folder"_redis-cluster-data-1
sudo docker volume rm -f "$folder"_redis-cluster-data-3
sudo docker volume rm -f "$folder"_redis-cluster-data-4
sudo docker volume rm -f "$folder"_redis-cluster-data-5

sudo docker-compose -f docker-compose-first-run.yml up -d && sudo docker-compose -f docker-compose-first-run.yml down