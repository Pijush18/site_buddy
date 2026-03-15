from pydantic import BaseModel
from typing import Optional

class AssistantQuery(BaseModel):
    prompt: str

class AssistantResponse(BaseModel):
    intent: str
    response: str
