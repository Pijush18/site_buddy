from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from sqlalchemy.ext.asyncio import AsyncSession
from app.db.database import get_db
from app.db.models import User
from sqlalchemy.future import select
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
        result = await db.execute(select(User).where(User.id == uid))
        user = result.scalars().first()
        
        if not user:
            user = User(id=uid, email=email)
            db.add(user)
            await db.commit()
            await db.refresh(user)
            
        return user
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=f"Invalid authentication credentials: {str(e)}",
            headers={"WWW-Authenticate": "Bearer"},
        )
