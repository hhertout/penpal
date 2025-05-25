from typing import Literal

class CharacterModel:
    name: str
    gender: str
    city: str
    country: str

    def __init__(self, name: str, city: str, country: str, gender: str = "m"):
        self.city = city
        self.country = country
        self.name = name
        self.gender = gender