import time
from fastapi import Request
from app.core.logging import logger

async def log_requests_middleware(request: Request, call_next):
    start_time = time.time()
    
    response = await call_next(request)
    
    process_time = time.time() - start_time
    logger.info(
        f"Method: {request.method} | Path: {request.url.path} | Status: {response.status_code} | Duration: {process_time:.4f}s"
    )
    
    return response
