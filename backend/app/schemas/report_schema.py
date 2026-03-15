from pydantic import BaseModel
from uuid import UUID
from datetime import datetime
from typing import Optional

class ReportBase(BaseModel):
    project_id: UUID

class ReportCreate(ReportBase):
    id: Optional[UUID] = None
    file_id: str
    file_name: str

class Report(ReportBase):
    id: UUID
    file_id: str
    file_name: str
    created_at: datetime
    file_url: Optional[str] = None
    
    class Config:
        from_attributes = True
