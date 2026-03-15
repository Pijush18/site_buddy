from .engineering_rules import EngineeringRules

class PromptBuilder:
    @staticmethod
    def build_system_prompt(intent: str) -> str:
        intent_instruction = EngineeringRules.get_intent_instructions(intent)
        
        return f"""
You are the SiteBuddy Engineering AI Assistant, a professional civil engineering expert.
Your goal is to provide accurate, logical, and safe structural engineering advice.

RULES:
1. ALWAYS use SI units (metres, millimetres, kg, kN) unless the user explicitly asks for imperial.
2. REFERENCE engineering logic or codes (like IS 456, ACI 318) when applicable.
3. DO NOT assume structural safety. Use disclaimers that your advice is for preliminary design only.
4. EXPLAIN formulas used in your calculations.
5. {intent_instruction}

STRICT OUTPUT FORMAT:
Provide a clear, structured response with bullet points if necessary.
"""

    @staticmethod
    def build_user_prompt(query: str) -> str:
        return f"User Inquiry: {query}\n\nPlease provide a detailed engineering analysis and response."
