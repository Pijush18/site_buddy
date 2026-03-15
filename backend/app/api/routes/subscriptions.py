from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from app.db.database import get_db
from app.schemas.subscription_schema import Subscription, SubscriptionUpdate, Entitlement
from app.services.subscription_service import SubscriptionService
from app.api.dependencies import get_current_user
from app.db.models import User

router = APIRouter()

@router.get("/status", response_model=Entitlement)
async def get_subscription_status(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    sub = await SubscriptionService.get_subscription(db, current_user.id)
    has_premium = await SubscriptionService.has_premium_access(db, current_user.id)
    return Entitlement(
        has_premium=has_premium,
        plan=sub.plan,
        status=sub.status
    )

@router.post("/validate", response_model=Subscription)
async def validate_subscription(
    purchase: SubscriptionUpdate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    return await SubscriptionService.validate_purchase(db, current_user.id, purchase)
