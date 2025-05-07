from fastapi import APIRouter
from pydantic import BaseModel
import jwt
from datetime import datetime, timedelta
import os
from config.logger import logger

class LoginArgs(BaseModel):
    username: str
    password: str

    def __repr__(self):
        return f"LoginArgs(username={self.username!r}, password=***hidden***)"

    def __str__(self):
        return self.__repr__()

router = APIRouter()

@router.post("/login")
def login(args: LoginArgs):
    # RATE LIMITER
    # TODO

    logger.info(f"Login args = {args}")

    payload = {
        "sub": args.username,
        "exp": datetime.now() + timedelta(days=10)
    }

    # Génération du token
    token = jwt.encode(payload, os.getenv("JWT_PASSPHRASE"), algorithm="HS256")
    return {"token": token}
