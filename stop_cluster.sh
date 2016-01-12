#!/bin/bash

echo "Stopping the Redis Replication Cluster with HAProxy on Docker Swarm"
docker-compose stop

echo "Cleaning up old containers for ports"
./cleanup_existing_cluster_containers.sh

echo "Done"

exit 0

