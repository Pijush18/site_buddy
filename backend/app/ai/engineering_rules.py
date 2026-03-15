import re

class EngineeringRules:
    @staticmethod
    def detect_intent(query: str) -> str:
        query = query.lower()
        
        rules = {
            "slab_design": [r"slab", r"floor", r"roof deck"],
            "beam_design": [r"beam", r"lintel", r"joist"],
            "footing_design": [r"footing", r"foundation", r"base"],
            "concrete_estimate": [r"concrete qty", r"concrete quantity", r"m3 of concrete"],
            "steel_estimate": [r"steel weight", r"rebar qty", r"reinforcement"],
        }
        
        for intent, patterns in rules.items():
            for pattern in patterns:
                if re.search(pattern, query):
                    return intent
        
        return "general_query"

    @staticmethod
    def get_intent_instructions(intent: str) -> str:
        instructions = {
            "slab_design": "Provide recommendations for slab thickness, reinforcement spacing, and clear cover based on IS 456 or standard code.",
            "beam_design": "Focus on longitudinal reinforcement, stirrups, and effective depth calculations.",
            "footing_design": "Consider soil bearing capacity and depth of foundation requirements.",
            "concrete_estimate": "Calculate volumes using L x B x H and apply waste factors (typically 5%).",
            "steel_estimate": "Use standard unit weights for rebar (e.g., D^2/162 kg/m).",
        }
        return instructions.get(intent, "Provide a helpful engineering response.")
