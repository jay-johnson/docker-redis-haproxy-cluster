#!/bin/bash

log="/tmp/local-consul.log"

echo "" > $log
echo "" >> $log
echo "Restarting Consul Server Agent" >> $log

# Make sure to stop the current ones if any
countconsul=`ps auwwx | grep 'consul agent' | grep -v grep | wc -l`

echo "Found Consul Agents that need to be stopped: $countconsul" >> $log
if [ $countconsul -gt 0 ]; then
  echo "Stopping Previous Consul" >> $log
  kill -9 `ps auwwx | grep 'consul agent' | grep -v grep | awk '{print $2}'` >> /dev/null
  echo "Done Stopping Previous Consul" >> $log
fi

# For HA consul needs to be running first:
consulinstances=1
consuldatadir="/opt/consul/data"
consullogdir="/opt/consul/logs"
consullogfile="/opt/consul/logs/consul.log"
if [ ! -d $consuldatadir ]; then
  mkdir -p $consuldatadir >> $log
  chmod 777 $consuldatadir >> $log
fi
if [ ! -d $consullogdir ]; then
  mkdir -p $consullogdir >> $log
  chmod 777 $consullogdir >> $log
fi
echo "" > $consullogfile
chmod 666 $consullogfile

echo "" >> $log
echo "Running as Bootstrap Server Node" >> $log
echo "" >> $log
consul agent -server -data-dir="/tmp/consul" -bind=0.0.0.0 -bootstrap-expect 1 &> $consullogfile &

exit 0

