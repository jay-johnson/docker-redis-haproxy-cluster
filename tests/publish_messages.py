#!/usr/bin/python

import sys, os, json, inspect
from redis_wrapper import RedisWrapper

port = 9000
queue = RedisWrapper("example_queue", host="localhost", port=port, db=0)

queue.put(9)
queue.put(8)
queue.put(7)
queue.put(6)
queue.put(5)


