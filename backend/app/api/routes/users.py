from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.core.database import get_db
from app.models.user import User
from pydantic import BaseModel
from datetime import datetime
import uuid

router = APIRouter()

class UserSyncRequest(BaseModel):
    firebase_uid: str
    email: str

class UserResponse(BaseModel):
    id: str
    firebase_uid: str
    email: str
    created_at: datetime

    class Config:
        from_attributes = True

@router.post("/sync", response_model=UserResponse)
def sync_user(request: UserSyncRequest, db: Session = Depends(get_db)):
    # 1. Check if user exists
    user = db.query(User).filter(User.firebase_uid == request.firebase_uid).first()
    
    # 2. If not, create new user
    if not user:
        user = User(
            id=str(uuid.uuid4()),
            firebase_uid=request.firebase_uid,
            email=request.email,
            created_at=datetime.utcnow()
        )
        db.add(user)
        db.commit()
        db.refresh(user)
        
    return user
