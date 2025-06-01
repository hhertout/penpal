from google import genai
from google.genai import types, Client
import os

from google.genai.types import GenerateContentResponse, Content, Part

from src.model.character_model import CharacterModel
from src.model.message_model import MessageModel
from typing import List, Literal


class Gemini:
    DEFAULT_MODEL: str = "gemini-2.0-flash"
    client: Client
    system_prompt: str
    correction_system_prompt: str
    character: CharacterModel
    user_country: str

    def __init__(self, character: CharacterModel, user_country: str="France"):
        self.user_country = user_country
        self.character = character
        self.client  = genai.Client(api_key=os.getenv("GEMINI_API_KEY"))

        self.system_prompt = (
            f"You are chatting as the user's best friend from an English-speaking country. "
            f"The user is from {self.user_country}. You know nothing from him. "
            "Never overdo it. Avoid sounding dramatic, poetic, or overly emotional. No emojis. Be relaxed and casual. "
            f"Your name is {self.character.name}, you are a {'man' if self.character.gender == 'm' else 'woman'}, and you live in {self.character.city}. "
            "You don’t know much about the user's life yet — so you're curious and want to get to know them. "
            "Ask only one casual question at a time. "
            "Do NOT act like an assistant or chatbot. "
            "Reply like a real friend in a text message — informal, and natural. "
            "Keep your replies short and conversational. Avoid long paragraphs or dramatic language. "
            "Avoid sounding overly excited or dramatic. No inspirational language, no emojis. "
            "Talk like a normal person texting a close friend. "
            "If the user makes a mistake in English, rephrase it naturally in your reply — without pointing it out. "
            "NEVER use phrases like 'How can I assist you'. "
            "NEVER offer help unless the user clearly asks for it. "
            "Make the chat feel friendly, simple, and real. "
        )

        self.correction_system_prompt = (
            "You are an English language corrector. **You speak french by default.** "
            "When the user sends a message, identify any grammar, spelling, or phrasing mistakes that would make the sentence unclear or incorrect. "
            "Explain what was wrong in a simple, friendly way, and provide a corrected version of the sentence using natural, everyday English. "
            "If the sentence is **perfectly correct and natural**, simply respond with **'C'est juste.'** (or 'C'est parfait !') without further explanation or conversational filler. "
            "Use standard American English, but be tolerant of common informal language, abbreviations, or slang (e.g., 'NYC', 'gonna', 'wanna', 'u') as long as they make sense in context. "
            "Do not overcorrect or make the sentence overly formal. "
            "Keep your tone helpful and supportive, but only when a correction is made. "
            f"The current region is the {self.character.country}. "
            "NEVER use phrases like 'How can I assist you' or 'Is there anything else I can help you with?'. "
            "NEVER offer help unless the user clearly asks for it. "
            "Your output should be concise."
        )

    def prompt(self, message:str) -> GenerateContentResponse:
        return self.client.models.generate_content(
            model=self.DEFAULT_MODEL,
            config=types.GenerateContentConfig(
                system_instruction=self.system_prompt),
            contents=message
        )

    def chat(self, message:str, kind: Literal["chat", "correction"], latest_message: List[MessageModel] = None) -> GenerateContentResponse:
        print(latest_message)
        chat_session = self.client.chats.create(
            model=self.DEFAULT_MODEL,
            config=types.GenerateContentConfig(
                system_instruction=self.system_prompt if kind == "chat" else self.correction_system_prompt
            ),
            history=self.format_message_for_gemini(latest_message)
        )
        return chat_session.send_message(message)

    @staticmethod
    def format_message_for_gemini(latest_message: List[MessageModel]):
        if len(latest_message) == 0:
            return []

        contents = []
        start_idx = 0
        if latest_message[0].sender == "ai":
            start_idx = 1

        for i in range(start_idx, len(latest_message)):
            msg = latest_message[i]
            role = "model" if msg.sender == "ai" else "user"
            contents.append(Content(role=role, parts=[Part.from_text(text=msg.message)]))

        return contents.reverse()