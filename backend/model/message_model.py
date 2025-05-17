from typing import Literal, Optional
from pydantic import BaseModel, Field
from pydantic import ConfigDict
from model.object_id import PyObjectId
from datetime import datetime

class MessageModel(BaseModel):
    id: PyObjectId = Field(default_factory=PyObjectId, alias="_id")
    conv_id: str
    ts: int = Field(default_factory=lambda: int(datetime.now().timestamp()))
    sender: Literal["ai", "user"]
    message: str
    correction: Optional[str] = None
    token_count: Optional[int] = None
    error: Optional[bool] = None

    model_config = ConfigDict(
        populate_by_name=True,
        arbitrary_types_allowed=True,
        extra='ignore'
    )
