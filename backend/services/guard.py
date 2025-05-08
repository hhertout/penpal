import os
from typing import Optional
from config.logger import logger

import jwt
from pydantic import BaseModel


class TokenClaim(BaseModel):
    username: str

def get_user_from_token(token: str) -> Optional[TokenClaim]:
    try:
        res = jwt.decode(jwt=token, key=os.getenv("JWT_PASSPHRASE"), algorithm="HS256")
        return TokenClaim(**res)
    except jwt.ExpiredSignatureError:
        logger.info("Token expired...")
    except jwt.InvalidTokenError:
        logger.warning("Invalid token.")

    return None
