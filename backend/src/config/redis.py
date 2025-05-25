import redis
import os

redis_rl = redis.Redis(host=os.getenv("REDIS_HOST"), port=6379, db=0)
redis_daily = redis.Redis(host=os.getenv("REDIS_HOST"), port=6379, db=1)