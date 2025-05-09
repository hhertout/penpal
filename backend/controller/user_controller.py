from typing import Annotated

from fastapi import APIRouter, HTTPException, Header
from pydantic import BaseModel

from config.logger import logger
from argon2 import PasswordHasher
from argon2.exceptions import VerifyMismatchError
from repository.user_repository import get_user_by_name, update_nickname
from services.rate_limiter import set_rate, is_rate_limited
from services import guard

class LoginArgs(BaseModel):
    username: str
    password: str

    def __repr__(self):
        return f"LoginArgs(username={self.username!r}, password=***hidden***)"

    def __str__(self):
        return self.__repr__()

class DefineNicknameArgs(BaseModel):
    nickname: str

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
    except HTTPException as e:
        raise e
    except VerifyMismatchError:
        logger.info(f"Login failed for user = {args.username}")
        raise HTTPException(status_code=400, detail="Invalid credentials")

    # JWT gen
    token = guard.generate_token(args.username)
    return {"token": token, "username": args.username}

@router.patch("/user/nickname")
def define_nickname(args: DefineNicknameArgs, authorization: Annotated[str | None, Header()] = None):
    claims = guard.get_user_from_token(authorization)
    if not claims:
        logger.info("Invalid token submit, request aborted")
        raise HTTPException(status_code=400, detail="Unauthorized")

    if args.nickname is None:
            raise HTTPException(status_code=400, detail="Nickname is required")
    
    try:
        res = update_nickname(claims.sub, args.nickname)
        if res.modified_count == 1:
            return {"status": "success", "id": str(res.upserted_id)}
        else:
            raise HTTPException(status_code=500, detail="Critical error")
    except HTTPException as e:
        raise e
    except Exception as e:
        logger.error(e)
        raise HTTPException(status_code=500, detail="Server error")

