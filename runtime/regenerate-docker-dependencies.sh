#!/bin/bash

# Remove redis-cluster volumes and remake them
cd redis-cluster
if ! sudo docker volume ls | grep -q "redis-cluster_redis-cluster"; then
    echo -e "No redis-cluster volumes found! Generating...\n"
    sudo wget -O docker-compose-first-run.yml https://raw.githubusercontent.com/bitnami/containers/fd15f56824528476ca6bd922d3f7ae8673f1cddd/bitnami/redis-cluster/7.0/debian-11/docker-compose.yml
    sudo docker-compose -f docker-compose-first-run.yml up -d && sudo docker-compose -f docker-compose-first-run.yml down
    rm docker-compose-first-run.yml
else
    echo -e "redis-cluster volumes found! Deleting and renerating...\n"
    sudo docker volume rm -f redis-cluster_redis-cluster_data-0
    sudo docker volume rm -f redis-cluster_redis-cluster_data-1
    sudo docker volume rm -f redis-cluster_redis-cluster_data-2
    sudo docker volume rm -f redis-cluster_redis-cluster_data-3
    sudo docker volume rm -f redis-cluster_redis-cluster_data-4
    sudo docker volume rm -f redis-cluster_redis-cluster_data-5

    sudo wget -O docker-compose-first-run.yml https://raw.githubusercontent.com/bitnami/containers/fd15f56824528476ca6bd922d3f7ae8673f1cddd/bitnami/redis-cluster/7.0/debian-11/docker-compose.yml
    sudo docker-compose -f docker-compose-first-run.yml up -d && sudo docker-compose -f docker-compose-first-run.yml down
    rm docker-compose-first-run.yml
fi

# Rebuild 'registration-service' docker image
cd registration-service
if ! sudo docker image ls | grep -q "registration-service"; then
    echo -e "No registration-service image found. Building...\n"
    sudo docker build -t registration-service:1.0 .
else
    echo -e "registration-service image found. Deleting and rebuilding...\n"
    sudo docker rmi -f registration-service:1.0
    sudo docker build --no-cache -t registration-service:1.0 .
fi
