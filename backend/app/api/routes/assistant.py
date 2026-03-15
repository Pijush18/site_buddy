from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from app.db.database import get_db
from app.schemas.assistant_schema import AssistantQuery, AssistantResponse
from app.services.assistant_service import AssistantService
from app.services.subscription_service import SubscriptionService
import uuid

from app.api.dependencies import get_current_user
from app.db.models import User

router = APIRouter()
assistant_service = AssistantService()

@router.post("/query", response_model=AssistantResponse)
async def query_assistant(
    query: AssistantQuery,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    # 1. SUBSCRIPTION CHECK
    has_premium = await SubscriptionService.has_premium_access(db, current_user.id)
    if not has_premium:
        raise HTTPException(
            status_code=403, 
            detail="AI Assistant requires a Premium Subscription. Upgrade to unlock Engineering AI."
        )

    return await assistant_service.handle_query(db, current_user.id, query.prompt)
