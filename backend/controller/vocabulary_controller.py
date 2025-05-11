import json

from model.character_model import CharacterModel
from model.daily_vocabulary_model import DailyVocabularyModel
from services.guard import get_user_from_token
from typing import Annotated
from fastapi import Header, APIRouter, HTTPException, status
from config.logger import logger
from services.llm import Llm
import json
import re
from repository import vocabulary_repository

router = APIRouter()

@router.get("/vocabulary/daily")
def get_daily_vocabulary(authorization: Annotated[str | None, Header()] = None):
    claims = get_user_from_token(authorization)
    if not claims:
        logger.info("Invalid token submit, request aborted")
        raise HTTPException(status_code=400, detail="Unauthorized")

    cache = vocabulary_repository.get_daily_vocabulary()
    if cache is not None:
        return json.loads(cache)

    llm = Llm(CharacterModel(name="vocab", city="None"))
    res = llm.prompt_for_daily_vocabulary()

    cleaned = re.sub(r"^```json\s*|\s*```$", "", res, flags=re.MULTILINE)

    vocabulary_repository.insert_daily_vocabulary(
        [DailyVocabularyModel(**word) for word in json.loads(cleaned)])
    vocabulary_repository.set_daily_vocabulary_cache(cleaned)

    return json.loads(cleaned)
