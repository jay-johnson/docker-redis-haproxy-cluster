#!/bin/bash

log="/tmp/local-daemon.log"

hostfqdn="localhost"
swarmdiscoveryport=4000
consuldiscoveryport=8500
dockerdiscoveryport=2375
uniqueswarmprefix="developmentswarm"

echo "Starting Docker Daemon: $hostfqdn:$dockerdiscoveryport " > $log

nohup /usr/local/bin/docker daemon -H $hostfqdn:$dockerdiscoveryport --cluster-advertise 0.0.0.0:$dockerdiscoveryport --cluster-store consul://$hostfqdn:$consuldiscoveryport/$uniqueswarmprefix  &> $log &

echo "Done Starting Docker Daemon" >> $log

exit 0

