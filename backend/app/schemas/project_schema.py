from pydantic import BaseModel
from uuid import UUID
from datetime import datetime
from typing import Optional, List

class ProjectBase(BaseModel):
    name: str
    location: Optional[str] = None
    description: Optional[str] = None

class ProjectCreate(ProjectBase):
    pass

class Project(ProjectBase):
    id: UUID
    user_id: UUID
    created_at: datetime

    class Config:
        from_attributes = True
