from app.ai.engineering_rules import EngineeringRules
from app.ai.prompt_builder import PromptBuilder
from app.ai.model_client import ModelClient
from app.schemas.assistant_schema import AssistantResponse
from sqlalchemy.ext.asyncio import AsyncSession
from app.db.models import AssistantHistory
import uuid

class AssistantService:
    def __init__(self):
        self._model_client = ModelClient()

    async def handle_query(self, db: AsyncSession, user_id: str, prompt: str) -> AssistantResponse:
        # 1. Detect Intent
        intent = EngineeringRules.detect_intent(prompt)
        
        # 2. Build Prompts
        sys_prompt = PromptBuilder.build_system_prompt(intent)
        user_prompt = PromptBuilder.build_user_prompt(prompt)
        
        # 3. Get AI Response
        response_text = await self._model_client.get_response(sys_prompt, user_prompt)
        
        # 4. Save to History
        history = AssistantHistory(
            user_id=user_id,
            prompt=prompt,
            response=response_text
        )
        db.add(history)
        await db.commit()
        
        return AssistantResponse(intent=intent, response=response_text)
