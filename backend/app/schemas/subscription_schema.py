from pydantic import BaseModel
from datetime import datetime
from typing import Optional
from uuid import UUID

class SubscriptionBase(BaseModel):
    plan: str
    status: str
    expiry_date: Optional[datetime] = None

class SubscriptionUpdate(BaseModel):
    purchase_token: str
    package_name: str
    product_id: str

class Subscription(SubscriptionBase):
    id: UUID
    user_id: str
    last_validated: datetime
    
    class Config:
        from_attributes = True

class Entitlement(BaseModel):
    has_premium: bool
    plan: str
    status: str
