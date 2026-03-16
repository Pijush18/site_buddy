from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from app.core.database import get_db
from app.api.dependencies import get_current_user
from app.models.user import User
from app.schemas.assistant_schema import AssistantQuery, AssistantResponse
from app.services.assistant_service import AssistantService
from app.services.subscription_service import SubscriptionService
from app.schemas.response_schema import ApiResponse, success_response

router = APIRouter(tags=["Assistant"])
assistant_service = AssistantService()

@router.post(
    "/query", 
    response_model=ApiResponse[AssistantResponse],
    summary="Query AI Assistant",
    description="Submits an engineering-related query to the SiteBuddy AI Assistant. Requires a premium subscription."
)
async def query_assistant(
    query: AssistantQuery,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    # Subscription Check
    has_premium = await SubscriptionService.has_premium_access(db, current_user.id)
    if not has_premium:
        raise HTTPException(
            status_code=403, 
            detail="AI Assistant requires a Premium Subscription. Upgrade to unlock Engineering AI."
        )

    response = await assistant_service.handle_query(db, current_user.id, query.prompt)
    return success_response(data=response, message="AI Assistant response received")
