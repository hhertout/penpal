import os
from typing import Optional
from config.logger import logger
from pydantic import BaseModel
from config.mongo import mongodb
from argon2 import PasswordHasher


class UserModel(BaseModel):
    username: str
    password: str

def get_user_by_name(username: str) -> Optional[UserModel]:
    user_data = mongodb.users.find_one({"username": username})
    if user_data:
        return UserModel(**user_data)
    return None

def insert_admin_user():
    admin = mongodb.users.find_one({"username": os.getenv("ADMIN_USERNAME")})

    if admin is None:
        ph = PasswordHasher()
        pwd_hash = ph.hash(password=os.getenv("ADMIN_PASSWORD"))
        admin = UserModel(username=os.getenv("ADMIN_USERNAME"),password=pwd_hash)
        mongodb.users.insert_one(admin.model_dump())
    else:
        logger.warning("Admin account already present... skipping...")