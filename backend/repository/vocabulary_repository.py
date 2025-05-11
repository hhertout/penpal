import json

from pymongo.results import InsertManyResult

from config.mongo import mongodb
from model.daily_vocabulary_model import DailyVocabularyModel
from typing import List
from config.redis import redis_daily

DAILY_EXPIRATION = 60 * 60 * 24  # 1d

def get_daily_vocabulary():
    return redis_daily.get("daily_vocabulary")

def set_daily_vocabulary_cache(data: str):
    return redis_daily.set("daily_vocabulary", data, ex=DAILY_EXPIRATION)

def insert_daily_vocabulary(vocab: List[DailyVocabularyModel]) -> InsertManyResult:
    return mongodb.daily_vocabulary.insert_many(
        [v.model_dump(by_alias=True, exclude={"id"}) for v in vocab])
