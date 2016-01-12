#!/bin/bash

redis-cli -p 19001 sentinel get-master-addr-by-name redis-cluster
