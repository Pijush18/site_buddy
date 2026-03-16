from fastapi import APIRouter
from app.api.routers import (
    auth_router, 
    project_router, 
    calculation_router, 
    report_router,
    assistant_router,
    subscription_router,
    system_router
)

api_router = APIRouter()

# System endpoints (root and health) 
api_router.include_router(system_router)

# Resource routers with versioned prefixes
api_router.include_router(auth_router, prefix="/auth")
api_router.include_router(project_router, prefix="/projects")
api_router.include_router(calculation_router, prefix="/calculations")
api_router.include_router(report_router, prefix="/reports")
api_router.include_router(assistant_router, prefix="/assistant")
api_router.include_router(subscription_router, prefix="/subscriptions")
