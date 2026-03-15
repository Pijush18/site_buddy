import google.generativeai as genai
from app.core.config import settings
import logging

logger = logging.getLogger(__name__)

class ModelClient:
    def __init__(self):
        if settings.GEMINI_API_KEY:
            genai.configure(api_key=settings.GEMINI_API_KEY)
            self.model = genai.GenerativeModel('gemini-pro')
        else:
            self.model = None
            logger.warning("GEMINI_API_KEY not found. AI responses will be mocked.")

    async def get_response(self, system_prompt: str, user_prompt: str) -> str:
        if not self.model:
            return self._mock_response(user_prompt)
        
        try:
            full_prompt = f"{system_prompt}\n\n{user_prompt}"
            response = await self.model.generate_content_async(full_prompt)
            return response.text
        except Exception as e:
            logger.error(f"AI Model Error: {str(e)}")
            return "Internal AI Error. Please try again later."

    def _mock_response(self, user_prompt: str) -> str:
        return f"MOCKED RESPONSE for: {user_prompt}\n\nPlease configure GEMINI_API_KEY in environment to enable real AI assistant."
