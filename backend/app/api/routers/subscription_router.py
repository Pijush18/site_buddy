from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from app.core.database import get_db
from app.api.dependencies import get_current_user
from app.models.user import User
from app.schemas.subscription_schema import Subscription, SubscriptionUpdate, Entitlement
from app.services.subscription_service import SubscriptionService
from app.schemas.response_schema import ApiResponse, success_response

router = APIRouter(tags=["Subscriptions"])

@router.get(
    "/status", 
    response_model=ApiResponse[Entitlement],
    summary="Get Subscription Status",
    description="Retrieves the current subscription plan and entitlement status for the authenticated user."
)
async def get_subscription_status(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    sub = await SubscriptionService.get_subscription(db, current_user.id)
    has_premium = await SubscriptionService.has_premium_access(db, current_user.id)
    data = Entitlement(
        has_premium=has_premium,
        plan=sub.plan,
        status=sub.status
    )
    return success_response(data=data, message="Subscription status retrieved")

@router.post(
    "/validate", 
    response_model=ApiResponse[Subscription],
    summary="Validate Purchase",
    description="Validates an App Store or Play Store purchase and updates the user's subscription status accordingly."
)
async def validate_subscription(
    purchase: SubscriptionUpdate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    subscription = await SubscriptionService.validate_purchase(db, current_user.id, purchase)
    return success_response(data=subscription, message="Purchase validated successfully")
