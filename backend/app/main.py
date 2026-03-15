from fastapi import FastAPI, Depends, Request
from fastapi.middleware.cors import CORSMiddleware
from app.core.config import settings
from app.api.routes import assistant, projects, calculations, reports, subscriptions, users
from app.api.middleware import log_requests_middleware
from slowapi import Limiter, _rate_limit_exceeded_handler
from slowapi.util import get_remote_address
from slowapi.errors import RateLimitExceeded
from sqlalchemy.orm import Session
from app.core.database import get_db
import time
from typing import Dict, Any

# Initialize Rate Limiter
limiter = Limiter(key_func=get_remote_address)

app = FastAPI(
    title=settings.PROJECT_NAME,
    openapi_url=f"{settings.API_V1_STR}/openapi.json"
)

app.state.limiter = limiter
app.add_exception_handler(RateLimitExceeded, _rate_limit_exceeded_handler)

# Middleware
@app.middleware("http")
async def add_process_time_header(request, call_next):
    return await log_requests_middleware(request, call_next)

# Set all CORS enabled origins
if settings.BACKEND_CORS_ORIGINS:
    app.add_middleware(
        CORSMiddleware,
        allow_origins=[str(origin) for origin in settings.BACKEND_CORS_ORIGINS],
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

@app.get("/")
@limiter.limit("5/minute")
async def root(request: Request):
    return {"message": "SiteBuddy API is Online", "version": "v1"}

@app.get("/health")
async def health_check(db: Session = Depends(get_db)):
    health_status: Dict[str, Any] = {
        "status": "healthy",
        "timestamp": time.time(),
        "services": {
            "database": "connected",
            "google_drive": "configured" if settings.GOOGLE_APPLICATION_CREDENTIALS else "missing"
        }
    }
    
    # 1. Database Check
    try:
        db.execute("SELECT 1")
    except Exception:
        health_status["services"]["database"] = "error"
        health_status["status"] = "degraded"
        
    return health_status

# Include Routers
app.include_router(assistant.router, prefix=f"{settings.API_V1_STR}/assistant", tags=["assistant"])
app.include_router(projects.router, prefix=f"{settings.API_V1_STR}/projects", tags=["projects"])
app.include_router(calculations.router, prefix=f"{settings.API_V1_STR}/calculations", tags=["calculations"])
app.include_router(reports.router, prefix=f"{settings.API_V1_STR}/reports", tags=["reports"])
app.include_router(subscriptions.router, prefix=f"{settings.API_V1_STR}/subscriptions", tags=["subscriptions"])
app.include_router(users.router, prefix=f"{settings.API_V1_STR}/users", tags=["users"])
