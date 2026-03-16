from typing import Any, Optional, Generic, TypeVar
from pydantic import BaseModel, Field

T = TypeVar("T")

class ApiResponse(BaseModel, Generic[T]):
    """
    Standardized API Response wrapper used across all SiteBuddy endpoints.
    """
    success: bool = Field(..., description="Indicates if the request was processed successfully.")
    data: Optional[T] = Field(None, description="The actual response payload.")
    message: Optional[str] = Field(None, description="A human-readable message about the operation.")
    error: Optional[str] = Field(None, description="Error details if success is false.")

    class Config:
        from_attributes = True

def success_response(data: Any = None, message: str = "Request successful") -> ApiResponse:
    return ApiResponse(success=True, data=data, message=message)

def error_response(message: str = "Request failed", error: str = None) -> ApiResponse:
    return ApiResponse(success=False, message=message, error=error)
