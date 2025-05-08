from typing import List, Literal
from pydantic import BaseModel, Field
import datetime
from pydantic import BaseModel, Field
from pydantic import ConfigDict
from model.object_id import PyObjectId

class Message(BaseModel):
    ts: datetime
    kind: Literal["in", "out"]
    message: str

class ConvModel(BaseModel):
    id: PyObjectId = Field(default_factory=PyObjectId, alias="_id")
    username: str
    messages: List[Message]

    model_config = ConfigDict(
        populate_by_name=True,
        arbitrary_types_allowed=True
    )
