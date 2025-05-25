from pydantic import BaseModel, Field
from pydantic import ConfigDict
from src.model.object_id import PyObjectId

class Character(BaseModel):
    name: str
    gender: str
    city: str
    country: str

class ConvModel(BaseModel):
    id: PyObjectId = Field(default_factory=PyObjectId, alias="_id")
    user_id: str
    name: str
    character: Character

    model_config = ConfigDict(
        populate_by_name=True,
        arbitrary_types_allowed=True,
        extra = 'ignore'
    )

