from fastapi import APIRouter, HTTPException
from pydantic import BaseModel

from config.logger import logger
from argon2 import PasswordHasher
from argon2.exceptions import VerifyMismatchError
from repository.user import get_user_by_name
from services.rate_limiter import set_rate, is_rate_limited
from services import guard

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
    is_rl = is_rate_limited(args.username)
    if is_rl:
        raise HTTPException(status_code=403, detail="Too many login attempts. Please wait a moment before trying again...")
    set_rate(args.username)

    # Login attempt
    logger.debug(f"Login args = {args}")
    user = get_user_by_name(args.username)
    if user is None:
        logger.info(f"Login failed for user = {args.username}")
        raise HTTPException(status_code=400, detail="Invalid credentials")

    ph = PasswordHasher()
    try:
        pwd_match = ph.verify(user.password, args.password)
        if not pwd_match:
            logger.info(f"Login failed for user = {args.username}")
            raise HTTPException(status_code=400, detail="Invalid credentials")
    except VerifyMismatchError:
        logger.info(f"Login failed for user = {args.username}")
        raise HTTPException(status_code=400, detail="Invalid credentials")

    # JWT gen
    token = guard.generate_token(args.username)
    return {"token": token, "username": args.username}
