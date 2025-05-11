import os

from pymongo import MongoClient

client = MongoClient(os.getenv("MONGO_URL"))
mongodb = client["penpal"]

mongodb.message.create_index([("conv_id", 1), ("ts", -1)])