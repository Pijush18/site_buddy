import time
from fastapi import Request
from app.core.logging import logger

async def log_requests_middleware(request: Request, call_next):
    """
    Middleware to log request details and execution time.
    Essential for debugging mobile-backend communication.
    """
    start_time = time.time()
    
    # Extract request info
    client_host = request.client.host if request.client else "unknown"
    method = request.method
    path = request.url.path
    
    try:
        response = await call_next(request)
        process_time = time.time() - start_time
        
        # Log success
        logger.info(
            f"Client: {client_host} | {method} {path} | Status: {response.status_code} | Duration: {process_time:.4f}s"
        )
        return response
    except Exception as e:
        process_time = time.time() - start_time
        # Log failure
        logger.error(
            f"Client: {client_host} | {method} {path} | ERROR: {str(e)} | Duration: {process_time:.4f}s"
        )
        raise e
