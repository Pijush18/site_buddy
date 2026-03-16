from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from app.core.database import get_db
from app.api.dependencies import get_current_user
from app.models.user import User
from app.models.project import Project as ProjectModel
from app.repositories.project_repository import ProjectRepository
from app.repositories.calculation_repository import CalculationRepository
from app.repositories.report_repository import ReportRepository
from app.schemas.project_schema import Project, ProjectCreate
from app.schemas.calculation_schema import Calculation
from app.schemas.report_schema import Report
from app.schemas.response_schema import ApiResponse, success_response
from typing import List
import uuid

router = APIRouter(tags=["Projects"])

@router.get(
    "/", 
    response_model=ApiResponse[List[Project]],
    summary="List Projects",
    description="Retrieves all engineering projects associated with the currently authenticated user."
)
async def list_projects(
    page: int = 1,
    limit: int = 20,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    project_repo = ProjectRepository(db)
    skip = (page - 1) * limit
    projects = await project_repo.get_by_user(current_user.id, skip=skip, limit=limit)
    return success_response(data=projects, message="Projects retrieved successfully")

@router.post(
    "/", 
    response_model=ApiResponse[Project],
    summary="Create Project",
    description="Creates a new engineering project for the authenticated user."
)
async def create_project(
    project_in: ProjectCreate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    project_repo = ProjectRepository(db)
    project_data = project_in.dict()
    project_data["user_id"] = current_user.id
    project_data["id"] = str(uuid.uuid4())
    project = await project_repo.create(obj_in=project_data)
    return success_response(data=project, message="Project created successfully")

@router.get(
    "/{id}", 
    response_model=ApiResponse[Project],
    summary="Get Project Details",
    description="Retrieves full details of a specific project by its ID, ensuring it belongs to the authenticated user."
)
async def get_project(
    id: str, 
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    project_repo = ProjectRepository(db)
    project = await project_repo.get(id)
    if not project or project.user_id != current_user.id:
        raise HTTPException(status_code=404, detail="Project not found")
    return success_response(data=project, message="Project retrieved successfully")

@router.get(
    "/{id}/calculations", 
    response_model=ApiResponse[List[Calculation]],
    summary="List Project Calculations",
    description="Retrieves all engineering calculations performed within a specific project."
)
async def list_project_calculations(
    id: str, 
    page: int = 1,
    limit: int = 20,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    # Verify project belongs to user
    project_repo = ProjectRepository(db)
    project = await project_repo.get(id)
    if not project or project.user_id != current_user.id:
        raise HTTPException(status_code=404, detail="Project not found")
        
    calc_repo = CalculationRepository(db)
    skip = (page - 1) * limit
    calculations = await calc_repo.get_by_project(id, skip=skip, limit=limit)
    return success_response(data=calculations, message="Calculations retrieved successfully")

@router.get(
    "/{id}/reports", 
    response_model=ApiResponse[List[Report]],
    summary="List Project Reports",
    description="Retrieves all PDF reports generated within a specific project."
)
async def list_project_reports(
    id: str, 
    page: int = 1,
    limit: int = 20,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    # Verify project belongs to user
    project_repo = ProjectRepository(db)
    project = await project_repo.get(id)
    if not project or project.user_id != current_user.id:
        raise HTTPException(status_code=404, detail="Project not found")
        
    report_repo = ReportRepository(db)
    skip = (page - 1) * limit
    reports = await report_repo.get_by_project(id, skip=skip, limit=limit)
    return success_response(data=reports, message="Reports retrieved successfully")
