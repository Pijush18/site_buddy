from fastapi import APIRouter, Depends, HTTPException, status, Request
from sqlalchemy.ext.asyncio import AsyncSession
from app.core.database import get_db
from app.repositories.user_repository import UserRepository
from app.models.user import User
from pydantic import BaseModel
from datetime import datetime
from typing import Optional, List
from app.api.dependencies import get_current_user
from app.schemas.response_schema import ApiResponse, success_response
from app.core.limiter import limiter

router = APIRouter(tags=["Auth"])

class UserSyncRequest(BaseModel):
    firebase_uid: str
    email: str

class UserResponse(BaseModel):
    id: str
    email: str
    created_at: datetime
    subscription_status: str

    class Config:
        from_attributes = True

@router.post(
    "/sync", 
    response_model=ApiResponse[UserResponse],
    summary="Synchronize User",
    description="Synchronizes a Firebase user with the local PostgreSQL database. If the user doesn't exist, a new record is created."
)
@limiter.limit("5/minute")
async def sync_user(request: UserSyncRequest, req: Request, db: AsyncSession = Depends(get_db)):
    user_repo = UserRepository(db)
    
    # Check if user exists
    user = await user_repo.get(request.firebase_uid)
    
    if not user:
        # Create new user
        user_data = {
            "id": request.firebase_uid,
            "email": request.email,
            "created_at": datetime.utcnow(),
            "subscription_status": "free"
        }
        user = await user_repo.create(obj_in=user_data)
        
    return success_response(data=user, message="User synced successfully")

@router.get(
    "/me", 
    response_model=ApiResponse[UserResponse],
    summary="Get Current User",
    description="Retrieves the profile of the currently authenticated user based on the Firebase ID token."
)
async def get_me(current_user: User = Depends(get_current_user)):
    return success_response(data=current_user, message="User retrieved successfully")
