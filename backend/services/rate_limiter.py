from typing import Optional

from config.redis import redis_rl
from config.logger import logger

DEFAULT_EXPIRATION = 60 * 60  # 1h
MAX_ATTEMPT = 5

def set_rate(username: str) -> int:
    count = redis_rl.get(username)
    count = int(count) if count else 0
    logger.info(f"RateLimiter COUNT for username {username} = {count}")

    redis_rl.set(username, count + 1, ex=DEFAULT_EXPIRATION)

    return count + 1

def get_rate(username: str) -> Optional[int]:
    count = redis_rl.get(username)
    return int(count) if count else None

def is_rate_limited(username: str) -> bool:
    count = redis_rl.get(username)
    return int(count) >= MAX_ATTEMPT if count else False