from typing import Optional

from bson import ObjectId
from pymongo.results import InsertOneResult, DeleteResult
from config.mongo import mongodb
from model.conv_model import ConvModel
from typing import List

def create_conv(conv: ConvModel) -> InsertOneResult:
    return mongodb.conv.insert_one(conv.model_dump(by_alias=True, exclude={"id"}))

def get_all_conversation(username: str) -> List[ConvModel]:
    cursor = mongodb.conv.find({"username": username})

    return [ConvModel(**conv) for conv in list(cursor)] if cursor is not None else []

def get_conversation_by_name(name: str) -> Optional[ConvModel]:
    conv = mongodb.conv.find_one({"name": name})

    return ConvModel(**conv) if conv is not None else None

def delete_conv_by_id(_id: str) -> DeleteResult:
    return mongodb.conv.delete_one({"_id": ObjectId(_id)})

def get_conversation_by_id(_id: str) -> Optional[ConvModel]:
    conv = mongodb.conv.find_one({"_id": ObjectId(_id)})

    return ConvModel(**conv) if conv is not None else None