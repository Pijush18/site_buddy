from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from app.core.database import get_db
from app.api.dependencies import get_current_user
from app.models.user import User
from app.repositories.calculation_repository import CalculationRepository
from app.schemas.calculation_schema import Calculation, CalculationCreate
from app.schemas.response_schema import ApiResponse, success_response
from typing import List
import uuid

router = APIRouter(tags=["Calculations"])

@router.get(
    "/", 
    response_model=ApiResponse[List[Calculation]],
    summary="List All Calculations",
    description="Retrieves a complete history of all engineering calculations performed by the authenticated user across all projects."
)
async def list_calculations(
    page: int = 1,
    limit: int = 20,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    calc_repo = CalculationRepository(db)
    skip = (page - 1) * limit
    calculations = await calc_repo.get_by_user(current_user.id, skip=skip, limit=limit)
    return success_response(data=calculations, message="Calculations retrieved successfully")

@router.post(
    "/", 
    response_model=ApiResponse[Calculation],
    summary="Save Calculation",
    description="Saves a new engineering calculation (e.g., slab design, concrete estimate) to a specific project."
)
async def create_calculation(
    calculation_in: CalculationCreate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    calc_repo = CalculationRepository(db)
    calculation_data = calculation_in.dict()
    calculation_data["user_id"] = current_user.id
    if not calculation_data.get("id"):
        calculation_data["id"] = str(uuid.uuid4())
    else:
        calculation_data["id"] = str(calculation_data["id"])
    
    # project_id should also be string in model
    calculation_data["project_id"] = str(calculation_data["project_id"])
    
    calculation = await calc_repo.create(obj_in=calculation_data)
    return success_response(data=calculation, message="Calculation saved successfully")

@router.get(
    "/{id}", 
    response_model=ApiResponse[Calculation],
    summary="Get Calculation Details",
    description="Retrieves the input parameters and results of a specific engineering calculation by its ID."
)
async def get_calculation(
    id: str, 
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    calc_repo = CalculationRepository(db)
    calculation = await calc_repo.get(id)
    if not calculation or calculation.user_id != current_user.id:
        raise HTTPException(status_code=404, detail="Calculation not found")
    return success_response(data=calculation, message="Calculation retrieved successfully")
