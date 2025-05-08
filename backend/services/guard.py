import json
import os
from typing import Optional
from config.logger import logger

import jwt
from pydantic import BaseModel
from datetime import datetime, timedelta

class TokenClaims(BaseModel):
    sub: str
    exp: int

def generate_token(username: str) -> str:
    token_exp = datetime.now() + timedelta(days=10)
    claims = TokenClaims(sub=username, exp=int(token_exp.timestamp()))
    return jwt.encode(claims.model_dump(), key=os.getenv("JWT_PASSPHRASE"), algorithm="HS256")

def get_user_from_token(token: str) -> Optional[TokenClaims]:
    try:
        claims = jwt.decode(jwt=token, key=os.getenv("JWT_PASSPHRASE"), algorithms=["HS256"])
        return TokenClaims(**claims)
    except jwt.ExpiredSignatureError:
        logger.info("Token expired...")
    except jwt.InvalidTokenError:
        logger.warning("Invalid token.")
    return None
