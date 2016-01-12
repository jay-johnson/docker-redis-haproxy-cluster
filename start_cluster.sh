#!/bin/bash

./cleanup_existing_cluster_containers.sh 

echo "Starting the Redis Replication Cluster with HAProxy on Docker Swarm"
docker-compose --x-networking --x-network-driver overlay up -d
echo "Done"


