from typing import List, Literal
from pydantic import BaseModel, Field
from pydantic import ConfigDict
from model.object_id import PyObjectId
from datetime import datetime

class Message(BaseModel):
    ts: int = Field(default_factory=lambda: int(datetime.now().timestamp()))
    kind: Literal["in", "out"]
    message: str

class ConvModel(BaseModel):
    id: PyObjectId = Field(default_factory=PyObjectId, alias="_id")
    name: str
    username: str
    messages: List[Message]

    model_config = ConfigDict(
        populate_by_name=True,
        arbitrary_types_allowed=True
    )

