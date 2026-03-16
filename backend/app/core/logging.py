import sys
from loguru import logger
from app.core.config import settings

def setup_logging():
    # Remove default handler
    logger.remove()
    
    # Add stdout handler with structured formatting
    # Level is controlled via ENVIRONMENT variables (defaulting to INFO)
    logger.add(
        sys.stdout,
        format="<green>{time:YYYY-MM-DD HH:mm:ss}</green> | <level>{level: <8}</level> | <cyan>{name}</cyan>:<cyan>{function}</cyan>:<cyan>{line}</cyan> - <level>{message}</level>",
        level=settings.LOG_LEVEL,
    )
    
    # Add file handler for production logs
    # Captures WARNING and higher to avoid bloat, but ensures critical issues are saved
    logger.add(
        "logs/app.log",
        rotation="10 MB",
        retention="10 days",
        level="WARNING",
        compression="zip",
    )

setup_logging()
