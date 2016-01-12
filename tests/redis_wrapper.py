import json

from functools import wraps
try:
    import cPickle as pickle
except ImportError:
    import pickle

from redis import Redis


class RedisWrapper(object):
    
    def __init__(self, name, serializer=pickle, **kwargs):
        self.m_debug = False
        self.m_name = name
        self.m_theserializer = serializer
        self.m_redis = Redis(**kwargs)

    # end of __init__


    def client_kill(self):
        self.m_redis.connection_pool.get_connection("QUIT").disconnect()
        return None
    # end of client_kill

    
    def __rlen(self):
        return self.m_redis.llen(self.key())
    # end of __rlen

    
    def allconsume(self, **kwargs):
        kwargs.setdefault('block', True)
        try:
            while True:
                msg = self.get(**kwargs)
                if msg is None:
                    break
                yield msg
        except KeyboardInterrupt:
            print; 
            return
    # end of consume

    
    def key(self):
        return "%s" % self.m_name
    # end of key
    
    
    def get_cached_multiple_set(self, start_idx=0, end_idx=-1, queue=None):

        if queue == None:
            msg = self.m_redis.lrange(self.key(), start_idx, end_idx)
        else:
            msg = self.m_redis.lrange(queue, start_idx, end_idx)

        if msg is not None and self.m_theserializer is not None:
            msg = self.m_theserializer.loads(msg[0])
    # end of get_cached_multiple_set


    def safe_get_cached_single_set(self, key):
        msg = {
                "Value"     : None,
                "Status"    : None,
                "Exception" : None
        }
        try:
            cached_msg  = self.m_redis.lrange(key, 0, 1)
            new_msg     = None

            if cached_msg is not None and len(cached_msg) != 0 and self.m_theserializer is not None:
                new_msg = self.m_theserializer.loads(cached_msg[0])

            msg["Value"]        = new_msg
            msg["Status"]       = "SUCCESS"
        # end of try

        except Exception, e:
            msg["Status"]       = "EXCEPTION"
            msg["Exception"]    = "Exception(" + str(e) + ")"
        # end of exception

        return msg
    # end of safe_get_cached_single_set


    def get_cached_single_set(self, queue=None):
        if queue == None:
            msg = self.m_redis.lrange(self.key(), 0, 1)
        else:
            msg = self.m_redis.lrange(queue, 0, 1)

        if msg is not None and self.m_theserializer is not None:
            msg = self.m_theserializer.loads(msg[0])
        return msg
    # end of get_cached_single_set


    def get(self, block=False, timeout=None, queue=None):
        msg = None
        if block:
            if timeout is None:
                timeout = 0

            if queue == None:
                msg = self.m_redis.blpop(self.key(), timeout=timeout)
            else:
                msg = self.m_redis.blpop(queue, timeout=timeout)

            if msg is not None:
                msg = msg[1]
        else:
            if queue == None:
                msg = self.m_redis.lpop(self.key())
            else:
                msg = self.m_redis.lpop(queue)

        if msg is not None and self.m_theserializer is not None:
            msg = self.m_theserializer.loads(msg)
        return msg
    # end of get
    

    def put_into_key(self, key, *msgs):
        if self.m_theserializer is not None:
            msgs = map(self.m_theserializer.dumps, msgs)

        self.m_redis.rpush(key, *msgs)
    # end of put_into_key


    def put(self, *msgs):
        if self.m_theserializer is not None:
            msgs = map(self.m_theserializer.dumps, msgs)

        self.m_redis.rpush(self.key(), *msgs)

    # end of put

    
    def exists(self, key):
        return self.m_redis.exists(key)
    # end of exists


    def delete_cache(self, queue=None):
        if queue == None:
            self.m_redis.delete(self.key())
        else:
            self.m_redis.delete(queue)
        return None
    # end of delete_cache


    def flush_all(self):
        self.m_redis.flushall()
        return None
    # end of flush_all

