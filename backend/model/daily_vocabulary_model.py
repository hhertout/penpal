from pydantic import BaseModel, Field
from pydantic import ConfigDict
from model.object_id import PyObjectId

class DailyVocabularyModel(BaseModel):
    id: PyObjectId = Field(default_factory=PyObjectId, alias="_id")
    en: str
    fr: str

    model_config = ConfigDict(
        populate_by_name=True,
        arbitrary_types_allowed=True,
        extra='ignore'
    )
