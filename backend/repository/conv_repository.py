from typing import Optional

from bson import ObjectId
from pymongo.results import InsertOneResult, UpdateResult, DeleteResult
from config.mongo import mongodb
from model.conv_model import ConvModel, Message
from typing import List

def create_conv(conv: ConvModel) -> InsertOneResult:
    return mongodb.conv.insert_one(conv.model_dump())

def add_message(conv_id: str, msg: Message) -> UpdateResult:
    conv = get_conversation_by_id(conv_id)
    if conv is None:
        raise Exception('conv does not exist')

    return mongodb.conv.update_one(
        {"_id": conv.id},
        {"$push": {"messages": msg.model_dump()}}
    )

def get_all_conversation(username: str) -> List[ConvModel]:
    convs_cursor = mongodb.conv.find({"username": username})
    convs = list(convs_cursor)

    return [ConvModel(**conv) for conv in convs]

def get_conversation_by_name(name: str) -> Optional[ConvModel]:
    conv = mongodb.conv.find_one({"name": name})
    if conv:
        return ConvModel(**conv)

    return None

def get_latest_message(conv_id: str, limit=10) -> List[Message] | None:
    res = mongodb.conv.find_one({
        "_id": ObjectId(conv_id),
    })

    if res["messages"]:
        res = res["messages"][-limit:]
        return [Message(**message) for message in res]
    else:
        return None

def delete_conv_by_id(_id: str) -> DeleteResult:
    return mongodb.conv.delete_one({"_id": ObjectId(_id)})

def get_conversation_by_id(_id: str) -> Optional[ConvModel]:
    conv = mongodb.conv.find_one({"_id": ObjectId(_id)})
    if conv:
        return ConvModel(**conv)

    return None