#!/bin/bash

log="/tmp/local-swarm.log"
hostfqdn="localhost"
swarmdiscoveryport=4000
consuldiscoveryport=8500
uniqueswarmprefix="developmentswarm"

echo "Starting Single Swarm Manager Listening on: $hostfqdn:$swarmdiscoveryport "
nohup /usr/local/bin/swarm manage -H tcp://$hostfqdn:$swarmdiscoveryport --advertise $hostfqdn:$swarmdiscoveryport consul://$hostfqdn:$consuldiscoveryport/$uniqueswarmprefix &> $log &

echo "Done Starting Swarm Manager"

exit 0

