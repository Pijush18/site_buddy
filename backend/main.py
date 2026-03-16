from fastapi import FastAPI, Depends, Request, HTTPException, status
from fastapi.responses import JSONResponse
from fastapi.middleware.cors import CORSMiddleware
from fastapi.exceptions import RequestValidationError
from app.core.config import settings
from app.api.api_router import api_router
from app.api.middleware import log_requests_middleware
from app.core.limiter import limiter
from slowapi import _rate_limit_exceeded_handler
from slowapi.errors import RateLimitExceeded
from app.core.database import get_db
from sqlalchemy import text
from sqlalchemy.ext.asyncio import AsyncSession
from app.schemas.response_schema import ApiResponse, success_response, error_response
import time
from typing import Dict, Any

app = FastAPI(
    title="SiteBuddy API",
    description="""
# SiteBuddy Engineering Backend
The SiteBuddy API provides a production-grade backend for the SiteBuddy Flutter application.

## Features
* **User Support**: Firebase Auth synchronization and user profile management.
* **Architecture Oversight**: Project-based organization for engineering tasks.
* **Engineering Tools**: Slab design, concrete estimates, and more.
* **AI Assistant**: Engineering intelligence powered by Gemini.
* **Reports**: Automated PDF generation and management.
    """,
    version="1.0.0",
    contact={
        "name": "SiteBuddy Development Team",
        "url": "https://sitebuddy.app/support",
        "email": "dev@sitebuddy.app",
    },
    openapi_url=f"{settings.API_V1_STR}/openapi.json",
    docs_url="/docs",
    redoc_url="/redoc",
    debug=settings.DEBUG, # Control detailed error pages
)

# Connect Rate Limiter to app
app.state.limiter = limiter
app.add_exception_handler(RateLimitExceeded, _rate_limit_exceeded_handler)

# --- Centralized Error Handling ---

@app.exception_handler(HTTPException)
async def http_exception_handler(request: Request, exc: HTTPException):
    return JSONResponse(
        status_code=exc.status_code,
        content=error_response(message=exc.detail, error=str(exc.detail)).dict()
    )

@app.exception_handler(RequestValidationError)
async def validation_exception_handler(request: Request, exc: RequestValidationError):
    errors = exc.errors()
    return JSONResponse(
        status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
        content=error_response(message="Input validation failed", error=str(errors)).dict()
    )

@app.exception_handler(Exception)
async def general_exception_handler(request: Request, exc: Exception):
    # Log the full traceback in production via middleware, but return clean JSON
    return JSONResponse(
        status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
        content=error_response(message="An unexpected error occurred", error=str(exc) if settings.DEBUG else "Internal Server Error").dict()
    )

# --- Middleware ---

@app.middleware("http")
async def add_process_time_header(request, call_next):
    return await log_requests_middleware(request, call_next)

# --- CORS Configuration ---

# Allow requests from Flutter app (localhost and production)
origins = [
    "http://localhost",
    "http://localhost:8080",
    "http://localhost:3000",
    "https://sitebuddy.app",
]

if settings.BACKEND_CORS_ORIGINS:
    origins.extend([str(origin) for origin in settings.BACKEND_CORS_ORIGINS if origin != "*"])

# Add specific wildcard support if configured as such
if "*" in settings.BACKEND_CORS_ORIGINS:
    allow_all = True
else:
    allow_all = False

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"] if allow_all else origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include Central Router with Prefix Versioning
app.include_router(api_router, prefix=settings.API_V1_STR)
