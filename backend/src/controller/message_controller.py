from typing import Annotated
from fastapi import Header, APIRouter, HTTPException
from pydantic import BaseModel
from src.config.logger import logger
from src.model.message_model import MessageModel
from src.services.guard import get_user_from_token
from src.repository import conv_repository
from src.repository import message_repository
from src.services.llm import Llm
from src.model.character_model import CharacterModel
from src.services.gemini import Gemini
from datetime import datetime

router = APIRouter()

class SendMessageArgs(BaseModel):
    conv_id: str
    message: str

@router.get("/messages/{conv_id}")
def get_message(conv_id: str, authorization: Annotated[str | None, Header()] = None):
    claims = get_user_from_token(authorization)
    if not claims:
        logger.info("Invalid token submit, request aborted")
        raise HTTPException(status_code=401, detail="Unauthorized")

    if conv_id is None:
        raise HTTPException(status_code=400, detail="conv id is not set")

    messages = message_repository.get_messages(conv_id)
    messages.reverse()

    return [msg.model_dump() for msg in messages]

@router.post("/message")
def send_message(args: SendMessageArgs, authorization: Annotated[str | None, Header()] = None):
    ts_now = int(datetime.now().timestamp())
    claims = get_user_from_token(authorization)
    if not claims:
        logger.info("Invalid token submit, request aborted")
        raise HTTPException(status_code=401, detail="Unauthorized")

    try:
        conv = conv_repository.get_conversation_by_id(_id=args.conv_id, user_id=claims.uid)
        if conv is None:
            raise HTTPException(status_code=404, detail="Conversation not found")
        logger.debug(f"conversation {conv.name} found; id={str(conv.id)}")

        latest_msg = message_repository.get_latest_message(conv_id=args.conv_id)
        char = CharacterModel(
            name=conv.character.name,
            city=conv.character.city,
            gender=conv.character.gender,
            country=conv.character.country
        )

        llm = Llm(char)
        gemini = Gemini(char)

        # gen response
        candidate = gemini.chat(args.message, kind="chat", latest_message=latest_msg)
        response = candidate.text
        logger.debug("AI response received")

        # gen correction
        candidate_res = gemini.chat(args.message, kind="correction", latest_message=latest_msg)
        correction = candidate_res.text
        #correction = llm.prompt_for_correction(args.message)
        logger.debug("AI correction received")

        # save the user prompt
        user_prompt = MessageModel(
                ts=ts_now,
                conv_id=args.conv_id,
                sender="user",
                message=args.message,
                correction=correction
        )
        insert = message_repository.insert_message(user_prompt)
        logger.debug(f"user message insert; id={str(insert.inserted_id)}")

        # save the AI response
        ai_response = MessageModel(
                conv_id=args.conv_id,
                sender="ai",
                message=response,
                token_count=candidate.usage_metadata.total_token_count,
        )

        insert = message_repository.insert_message(ai_response)
        logger.debug(f"ai response and correction insert; id={str(insert.inserted_id)}")

        return {
            "response": response,
            "correction": correction
        }
    except HTTPException as e:
        raise e
    except Exception as e:
        logger.error(e)
        raise HTTPException(status_code=500, detail="Server error")
