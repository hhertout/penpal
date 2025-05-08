import os
from typing import Optional
from config.logger import logger

import jwt
from pydantic import BaseModel
from datetime import datetime, timedelta

class TokenClaims(BaseModel):
    username: str

def generate_token(username: str) -> str:
    payload = {
        "sub": username,
        "exp": datetime.now() + timedelta(days=10)
    }
    return jwt.encode(payload, key=os.getenv("JWT_PASSPHRASE"), algorithm="HS256")

def get_user_from_token(token: str) -> Optional[TokenClaims]:
    try:
        res = jwt.decode(jwt=token, key=os.getenv("JWT_PASSPHRASE"), algorithm="HS256")
        return TokenClaims(**res)
    except jwt.ExpiredSignatureError:
        logger.info("Token expired...")
    except jwt.InvalidTokenError:
        logger.warning("Invalid token.")

    return None
