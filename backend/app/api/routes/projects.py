from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from app.db.database import get_db
from app.schemas.project_schema import Project, ProjectCreate
from app.services.project_service import ProjectService
from app.schemas.calculation_schema import Calculation
from app.services.calculation_service import CalculationService
from typing import List
import uuid

from app.api.dependencies import get_current_user
from app.db.models import User

router = APIRouter()
project_service = ProjectService()
calculation_service = CalculationService()

@router.get("/", response_model=List[Project])
async def list_projects(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    return await project_service.get_projects(db, current_user.id)

@router.post("/", response_model=Project)
async def create_project(
    project_in: ProjectCreate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    return await project_service.create_project(db, current_user.id, project_in)

@router.get("/{id}", response_model=Project)
async def get_project(
    id: uuid.UUID, 
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    project = await project_service.get_project(db, id, current_user.id)
    if not project:
        raise HTTPException(status_code=404, detail="Project not found")
    return project

@router.get("/{id}/calculations", response_model=List[Calculation])
async def list_project_calculations(id: uuid.UUID, db: AsyncSession = Depends(get_db)):
    return await calculation_service.get_calculations_by_project(db, id)
