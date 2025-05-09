from typing import Annotated

from fastapi import Header, APIRouter, HTTPException, status
from pydantic import BaseModel
from config.logger import logger
from services.guard import get_user_from_token
from repository import conv_repository
from model.conv_model import Message
from services.llm import Llm, Character

router = APIRouter()

class SendMessageArgs(BaseModel):
    conv_id: str
    message: str

@router.post("/message")
def send_message(args: SendMessageArgs, authorization: Annotated[str | None, Header()] = None):
    claims = get_user_from_token(authorization)
    if not claims:
        logger.info("Invalid token submit, request aborted")
        raise HTTPException(status_code=400, detail="Unauthorized")

    try:
        conv_repository.add_message(
            conv_id=args.conv_id,
            msg=Message(sender="user", message=args.message)
        )

        latest_msg = conv_repository.get_latest_message(conv_id=args.conv_id)

        char = Character(name="Tony", city="New York")
        llm = Llm(char)
        res = llm.prompt(args.message, latest_msg)
        correction = llm.prompt_for_correction(args.message)

        conv_repository.add_message(
            conv_id=args.conv_id,
            msg=Message(sender="ai", message=res, correction=correction)
        )

        return {"response": res, "correction": correction}
    except HTTPException as e:
        raise e
    except Exception as e:
        logger.error(e)
        raise HTTPException(status_code=500, detail="Server error")
