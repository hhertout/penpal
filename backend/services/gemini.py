from google import genai
from google.genai import types, Client
import os

from google.genai.types import GenerateContentResponse

from model.character_model import CharacterModel
from model.message_model import MessageModel

from typing import List


class Gemini:
    DEFAULT_MODEL: str = "gemini-2.0-flash"
    client: Client
    system_prompt: str
    character: CharacterModel
    user_country: str

    def __init__(self, character: CharacterModel, user_country: str= "France"):
        self.user_country = user_country
        self.character = character
        self.client  = genai.Client(api_key=os.getenv("GEMINI_API_KEY"))

        self.system_prompt = (
            f"You are chatting as the user's best friend from an English-speaking country. "
            f"The user is from {self.user_country}. "
            "Never overdo it. Avoid sounding dramatic, poetic, or overly emotional. No emojis. Be relaxed and casual. "
            f"Your name is {self.character.name}, you are a {'man' if self.character.gender == 'm' else 'woman'}, and you live in {self.character.city}. "
            "You don’t know much about the user's life yet — so you're curious and want to get to know them. "
            "Ask only one casual question at a time. "
            "Do NOT act like an assistant or chatbot. "
            "Reply like a real friend in a text message — informal, relaxed, and natural. "
            "Keep your replies short and conversational. Avoid long paragraphs or dramatic language. "
            "Avoid sounding overly excited or dramatic. No inspirational language, no emojis. "
            "Talk like a normal person texting a close friend. "
            "If the user makes a mistake in English, rephrase it naturally in your reply — without pointing it out. "
            "NEVER use phrases like 'How can I assist you'. "
            "NEVER offer help unless the user clearly asks for it. "
            "Make the chat feel friendly, simple, and real. "
        )

    def prompt(self, message:str) -> GenerateContentResponse:
        return self.client.models.generate_content(
            model=self.DEFAULT_MODEL,
            config=types.GenerateContentConfig(
                system_instruction=self.system_prompt),
            contents=message
        )

    def chat(self, message:str, latest_message: List[MessageModel]) -> GenerateContentResponse:
        chat_session = self.client.chats.create(
            model=self.DEFAULT_MODEL,
            config=types.GenerateContentConfig(system_instruction=self.system_prompt),
            history=self.format_message(latest_message)
        )
        return chat_session.send_message(message)

    @staticmethod
    def format_message(latest_message: List[MessageModel]):
        res = []
        for msg in latest_message:
            res.append({
                "role": "model" if msg.sender == "ai" else "user",
                "parts": [msg.message]
            })

        return res