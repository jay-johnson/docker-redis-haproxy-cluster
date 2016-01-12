#!/usr/bin/python

import sys, os, json, inspect
from redis_wrapper import RedisWrapper

port = 9000
queue = RedisWrapper("example_queue", host="localhost", port=port, db=0)

while True:
    print "Got this: " + str(queue.get(True))


