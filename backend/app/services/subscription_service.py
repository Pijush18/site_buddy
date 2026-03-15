from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from app.db.models import Subscription, User
from app.schemas.subscription_schema import SubscriptionUpdate
from datetime import datetime, timedelta
import uuid

class SubscriptionService:
    @staticmethod
    async def get_subscription(db: AsyncSession, user_id: str) -> Subscription:
        result = await db.execute(select(Subscription).where(Subscription.user_id == user_id))
        sub = result.scalars().first()
        if not sub:
            # Create a default free subscription
            sub = Subscription(
                user_id=user_id,
                plan="free",
                status="active",
                expiry_date=None
            )
            db.add(sub)
            await db.commit()
            await db.refresh(sub)
        return sub

    @staticmethod
    async def validate_purchase(db: AsyncSession, user_id: str, purchase: SubscriptionUpdate) -> Subscription:
        # In a real app, this would verify the token with Google Play / Apple Store APIs
        # For now, we simulate a successful validation for a 'premium' plan
        
        sub = await SubscriptionService.get_subscription(db, user_id)
        sub.plan = "premium"
        sub.status = "active"
        sub.expiry_date = datetime.utcnow() + timedelta(days=30)
        sub.last_validated = datetime.utcnow()
        
        await db.commit()
        await db.refresh(sub)
        return sub

    @staticmethod
    async def has_premium_access(db: AsyncSession, user_id: str) -> bool:
        sub = await SubscriptionService.get_subscription(db, user_id)
        if sub.plan in ["premium", "professional"] and sub.status == "active":
            # Check for expiry
            if sub.expiry_date and sub.expiry_date < datetime.utcnow():
                sub.status = "expired"
                await db.commit()
                return False
            return True
        return False
