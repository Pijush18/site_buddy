from fastapi import APIRouter, Depends, Request, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import text
from app.core.database import get_db
from app.schemas.response_schema import ApiResponse, success_response, error_response
from app.core.limiter import limiter
import time

router = APIRouter(tags=["System"])

@router.get(
    "/", 
    response_model=ApiResponse,
    summary="API Root",
    description="Returns the current API status and version information."
)
@limiter.limit("10/minute")
async def root(request: Request):
    return success_response(
        data={"version": "v1.0.0", "status": "online"},
        message="SiteBuddy API is Online"
    )

@router.get(
    "/health", 
    # health is not response_model=ApiResponse in previous view but I'll make it consistent
    response_model=ApiResponse,
    summary="Health Check",
    description="Verifies the health of the API server and its core services including the PostgreSQL database."
)
@limiter.limit("5/minute")
async def health_check(request: Request, db: AsyncSession = Depends(get_db)):
    health_status = {
        "status": "healthy",
        "timestamp": time.time(),
        "services": {
            "database": "connected"
        }
    }
    try:
        await db.execute(text("SELECT 1"))
    except Exception as e:
        health_status["status"] = "degraded"
        health_status["services"]["database"] = f"error: {str(e)}"
        return ApiResponse(success=False, data=health_status, message="Service degraded", error=str(e))
        
    return success_response(data=health_status, message="System is healthy")
