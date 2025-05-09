import os
from config.logger import logger
import requests
import json
from typing import Literal

from model.conv_model import Message
from typing import List


class Character:
    name: str
    gender: Literal["m", "f"]
    city: str

    def __init__(self, name: str, city: str, gender: Literal["m", "f"] = "m"):
        self.city = city
        self.name = name
        self.gender = gender

class Llm:
    DEFAULT_MODEL = "phi4-mini"
    DEEPSEEK_R1 = "deepseek-r1:7b"

    endpoint: str | None = os.getenv("LLM_ENDPOINT")
    character: Character
    system_prompt: str
    corrector_system_prompt: str

    def __init__(self, character: Character):
        if self.endpoint is None:
            logger.error("LLM_ENDPOINT is not defined")
            raise Exception("LLM_ENDPOINT is not defined")

        self.character = character
        self.system_prompt = (
            f"You are chatting as the user's best friend from an English-speaking country. "
            "The user is from France. "
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

        self.corrector_system_prompt = (
            "You are an English language corrector. You speak french by default. "
            "When the user sends a message, identify any grammar, spelling, or phrasing mistakes that would make the sentence unclear or incorrect. "
            "Explain what was wrong in a simple, friendly way, and provide a corrected version of the sentence using natural, everyday English. "
            "Use standard American English, but be tolerant of common informal language, abbreviations, or slang (e.g., 'NYC', 'gonna', 'wanna', 'u') as long as they make sense in context. "
            "Do not overcorrect or make the sentence overly formal. "
            "Keep your tone helpful and supportive. The current region is the USA. "
        )

    def prompt_for_correction(self, prompt: str) -> str:
        llm_response = ""
        messages = [
            {"role": "system", "content": self.corrector_system_prompt},
            {"role": "user", "content": prompt}
        ]

        res = requests.post(
            url=f"{self.endpoint}/api/chat",
            json={
                "model": self.DEFAULT_MODEL,
                "messages": messages,
                "stop": ["---", "Instruction:"],
                "stream": True
            },
            stream=True
        )

        for line in res.iter_lines():
            if line:
                data: dict = json.loads(line.decode('utf-8'))
                llm_response += data.get("message", {}).get("content", "")

        return llm_response.strip()

    def prompt(self, prompt: str, latest_messages: List[Message] = None) -> str:
        llm_response = ""
        messages = [{"role": "system", "content": self.system_prompt}]

        if latest_messages is not None:
            for msg in latest_messages:
                messages.append({
                    "role": "assistant" if msg.sender == "ai" else "user",
                    "content": msg.message
                })

        messages.append({"role": "user", "content": prompt})

        res = requests.post(
            url=f"{self.endpoint}/api/chat",
            json={
                "model": self.DEFAULT_MODEL,
                "messages": messages,
                "stop": ["---", "Instruction:"],
                "stream": True
            },
            stream=True
        )

        for line in res.iter_lines():
            if line:
                data: dict = json.loads(line.decode('utf-8'))
                llm_response += data.get("message", {}).get("content", "")

        return llm_response.strip()




