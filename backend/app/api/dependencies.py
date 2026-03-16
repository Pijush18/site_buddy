from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from sqlalchemy.ext.asyncio import AsyncSession
from app.core.database import get_db
from app.models.user import User
from sqlalchemy.future import select
from app.repositories.user_repository import UserRepository
from datetime import datetime
import firebase_admin
from firebase_admin import auth, credentials
import os

# Initialize Firebase (assuming credentials either via service account file or default)
try:
    if not firebase_admin._apps:
        # In a real environment, use a service account file
        # cred = credentials.Certificate("path/to/serviceAccountKey.json")
        # firebase_admin.initialize_app(cred)
        firebase_admin.initialize_app()
except Exception:
    # Fallback for local dev without firebase setup
    pass

security = HTTPBearer()

async def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(security),
    db: AsyncSession = Depends(get_db)
) -> User:
    token = credentials.credentials
    try:
        # 1. Verify token with Firebase
        decoded_token = auth.verify_id_token(token)
        uid = decoded_token['uid']
        email = decoded_token.get('email')
        
        # 2. Check if user exists in DB, if not create
        user_repo = UserRepository(db)
        user = await user_repo.get(uid)
        
        if not user:
            user_data = {
                "id": uid,
                "email": email,
                "created_at": datetime.utcnow()
            }
            user = await user_repo.create(obj_in=user_data)
            
        return user
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=f"Invalid authentication credentials: {str(e)}",
            headers={"WWW-Authenticate": "Bearer"},
        )
