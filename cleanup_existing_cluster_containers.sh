#!/bin/bash

docker stop localhost.localdomain/haproxynode1 localhost.localdomain/redisnode1 localhost.localdomain/redisnode2 localhost.localdomain/redisnode3 

docker rm localhost.localdomain/haproxynode1 localhost.localdomain/redisnode1 localhost.localdomain/redisnode2 localhost.localdomain/redisnode3 

exit 0

