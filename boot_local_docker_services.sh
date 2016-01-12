#!/bin/bash

consulpid=`ps auwwx | grep "consul agent -server" | awk '{print $2}'`
dockerpid=`ps auwwx | grep "docker daemon" | awk '{print $2}'`
swarmmanpid=`ps auwwx | grep "swarm manage" | awk '{print $2}'`
swarmjoinpid=`ps auwwx | grep "swarm join" | awk '{print $2}'`

echo "Stopping all services"
kill -9 $consulpid $dockerpid $swarmmanpid $swarmjoinpid

pushd docker-services >> /dev/null

echo ""
echo "Starting Consul"
pushd consul >> /dev/null
./restart_consul.sh
popd >> /dev/null

echo "Waiting on consul to start"
sleep 5

echo "Starting Docker"
pushd docker >> /dev/null
./start_docker_daemon.sh
popd >> /dev/null

echo "Waiting on docker daemon to start"
sleep 2
echo "Starting Swarm Manager"
pushd swarm >> /dev/null
./restart_single_swarm_manager.sh
sleep 2
./swarm_join_local_consul.sh
popd >> /dev/null

popd >> /dev/null

exit 0
