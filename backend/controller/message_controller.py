from typing import Annotated
from fastapi import Header, APIRouter, HTTPException, status
from pydantic import BaseModel
from config.logger import logger
from model.message_model import MessageModel
from services.guard import get_user_from_token
from repository import conv_repository, message_repository
from services.llm import Llm
from model.character_model import CharacterModel
from services.gemini import Gemini
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
        conv = conv_repository.get_conversation_by_id(args.conv_id)
        if conv is None:
            raise HTTPException(status_code=404, detail="Conversation not found")
        logger.debug(f"conversation {conv.name} found; id={str(conv.id)}")

        latest_msg = message_repository.get_latest_message(conv_id=args.conv_id)
        char = CharacterModel(name="Tony", city="New York")

        llm = Llm(char)
        gemini = Gemini(char)

        # gen response
        candidate = gemini.chat(args.message, latest_message=latest_msg)
        response = candidate.text
        logger.debug("AI response received")

        # gen correction
        correction = llm.prompt_for_correction(args.message)
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
