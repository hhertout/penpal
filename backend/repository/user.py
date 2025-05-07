import os
from typing import Optional

from pydantic import BaseModel

from config.mongo import mongodb


class UserModel(BaseModel):
    username: str
    password: str

def get_user_by_name(username: str) -> Optional[UserModel]:
    user_data = mongodb.users.find_one({"username": username})
    if user_data:
        return UserModel(**user_data)
    return None

def insert_admin_user():
    admin = UserModel(username=os.getenv("ADMIN_USERNAME"),password=os.getenv("ADMIN_PASSWORD"))

    mongodb.users.insert_one(admin.model_dump())