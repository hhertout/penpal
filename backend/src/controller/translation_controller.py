from typing import Annotated

from fastapi import APIRouter, HTTPException, Header
from pydantic import BaseModel

from src.config.logger import logger
from src.services.guard import get_user_from_token
from src.services.gemini import Gemini

router = APIRouter()

class GetCorrectionTranslationRequest(BaseModel):
    to_translate: str
    translation: str

@router.get("/to_translate")
def get_sentence_to_translate(authorization: Annotated[str | None, Header()] = None):
    claims = get_user_from_token(authorization)
    if not claims:
        logger.info("Invalid token submit, request aborted")
        raise HTTPException(status_code=401, detail="Unauthorized")

    gemini = Gemini()
    candidate = gemini.quick_prompt(gemini.random_french_phrase_prompt)
    return {"sentence": candidate.text}


@router.post("/to_translate")
def get_correction_of_translation(args: GetCorrectionTranslationRequest,authorization: Annotated[str | None, Header()] = None):
    claims = get_user_from_token(authorization)
    if not claims:
        logger.info("Invalid token submit, request aborted")
        raise HTTPException(status_code=401, detail="Unauthorized")

    gemini = Gemini()
    candidate = gemini.translate_correction(input=args.to_translate, translation=args.translation)
    return {"sentence": candidate.text}