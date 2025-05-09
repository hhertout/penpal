from pydantic import BaseModel
from services.guard import get_user_from_token
from typing import Annotated
from fastapi import Header, APIRouter, HTTPException, status
from config.logger import logger
from repository import conv_repository
from model.conv_model import ConvModel

class NewConvArgs(BaseModel):
    name: str

router = APIRouter()

@router.post("/conv/new", status_code=status.HTTP_201_CREATED)
def create_conv(args: NewConvArgs, authorization: Annotated[str | None, Header()] = None):
    claims = get_user_from_token(authorization)
    if not claims:
        logger.info("Invalid token submit, request aborted")
        raise HTTPException(status_code=400, detail="Unauthorized")

    if args.name is None:
        raise HTTPException(status_code=400, detail="Name of the conversation is required")

    try:
        res = conv_repository.get_conversation_by_name(args.name)
        if res:
            raise HTTPException(status_code=400, detail="Conversation already exist")
        conv = ConvModel(username=claims.sub, name=args.name, messages=[])
        new_conv = conv_repository.create_conv(conv)
        print(new_conv)

        return {"status": "success", "id": str(new_conv.inserted_id)}
    except HTTPException as e:
        raise e
    except Exception as e:
        logger.error(e)
        raise HTTPException(status_code=500, detail="Server error")

@router.get("/conv")
def get_all_conv(authorization: Annotated[str | None, Header()] = None):
    claims = get_user_from_token(authorization)
    if not claims:
        logger.info("Invalid token submit, request aborted")
        raise HTTPException(status_code=400, detail="Unauthorized")

    try:
        return conv_repository.get_all_conversation(claims.sub)
    except HTTPException as e:
        raise e
    except Exception as e:
        logger.error(e)
        raise HTTPException(status_code=500, detail="Server error")

@router.get("/conv/{conv_id}")
def get_conv_by_id(conv_id: str, authorization: Annotated[str | None, Header()] = None):
    claims = get_user_from_token(authorization)
    if not claims:
        logger.info("Invalid token submit, request aborted")
        raise HTTPException(status_code=400, detail="Unauthorized")

    if conv_id is None:
        raise HTTPException(status_code=400, detail="conv id is not set")

    try:
        conv = conv_repository.get_conversation_by_id(conv_id)
        if conv is None:
            raise HTTPException(status_code=404, detail="Conversation not found")
    except HTTPException as e:
        raise e
    except Exception as e:
        logger.error(e)
        raise HTTPException(status_code=500, detail="Server error")

@router.delete("/conv/{conv_id}")
def delete_conv(conv_id: str, authorization: Annotated[str | None, Header()] = None):
    claims = get_user_from_token(authorization)
    if not claims:
        logger.info("Invalid token submit, request aborted")
        raise HTTPException(status_code=400, detail="Unauthorized")

    if conv_id is None:
        raise HTTPException(status_code=400, detail="conv id is not set")

    conv = conv_repository.get_conversation_by_id(conv_id)
    if conv is None:
        raise HTTPException(status_code=400, detail="Conversation does not exist")

    try:
        res = conv_repository.delete_conv_by_id(conv_id)
        if res.deleted_count == 1:
            return {"status": "success"}
        else:
            raise HTTPException(status_code=500, detail="An error has occurred during the suppression of the conversation")
    except HTTPException as e:
        raise e
    except Exception as e:
        logger.error(e)
        raise HTTPException(status_code=500, detail="Server error")