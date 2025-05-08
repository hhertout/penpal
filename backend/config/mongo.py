import os

from pymongo import MongoClient

client = MongoClient(os.getenv("MONGO_URL"))
mongodb = client["penpal"]