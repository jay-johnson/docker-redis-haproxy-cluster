#!/bin/bash

log="/tmp/local-joinswarm.log"
hostfqdn="localhost"
swarmdiscoveryport=4000
consuldiscoveryport=8500
uniqueswarmprefix="developmentswarm"

echo "Starting Swarm Join on: consul://$hostfqdn:$consuldiscoveryport/$uniqueswarmprefix" > $log
nohup /usr/local/bin/swarm join --addr=$hostfqdn:2375 consul://$hostfqdn:$consuldiscoveryport/$uniqueswarmprefix &> $log &

echo "Done Starting Swarm Join" >> $log

exit 0

