from pydantic import BaseModel
from uuid import UUID
from datetime import datetime
from typing import Optional, Any, Dict

class CalculationBase(BaseModel):
    project_id: UUID
    type: str
    input_data: Dict[str, Any]
    result_data: Dict[str, Any]
    created_at: Optional[datetime] = None

class CalculationCreate(CalculationBase):
    id: Optional[UUID] = None

class Calculation(CalculationBase):
    id: UUID
    
    class Config:
        from_attributes = True
