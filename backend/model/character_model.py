from typing import Literal

class CharacterModel:
    name: str
    gender: Literal["m", "f"]
    city: str

    def __init__(self, name: str, city: str, gender: Literal["m", "f"] = "m"):
        self.city = city
        self.name = name
        self.gender = gender