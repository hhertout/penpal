from bson import ObjectId
from pymongo.results import InsertOneResult
from config.mongo import mongodb
from model.message_model import MessageModel
from typing import List

def insert_message(message: MessageModel) -> InsertOneResult:
    return mongodb.message.insert_one(message.model_dump(by_alias=True, exclude={"id"}))

def get_messages(conv_id: str) -> List[MessageModel]:
    cursor =  mongodb.message.find({
        "conv_id": ObjectId(conv_id)
    })

    return [MessageModel(**msg) for msg in list(cursor)] if cursor is not None else []

def get_latest_message(conv_id, limit = 10) -> List[MessageModel]:
    cursor = mongodb.message.find({"conv_id": ObjectId(conv_id)}).sort("ts", -1).limit(limit)

    return [MessageModel(**msg) for msg in list(cursor)] if cursor is not None else []