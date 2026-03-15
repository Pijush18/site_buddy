from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from app.db.models import Project
from app.schemas.project_schema import ProjectCreate
import uuid

class ProjectService:
    @staticmethod
    async def get_projects(db: AsyncSession, user_id: str):
        result = await db.execute(select(Project).where(Project.user_id == user_id))
        return result.scalars().all()

    @staticmethod
    async def create_project(db: AsyncSession, user_id: str, project_in: ProjectCreate):
        db_project = Project(
            **project_in.model_dump(),
            user_id=user_id
        )
        db.add(db_project)
        await db.commit()
        await db.refresh(db_project)
        return db_project

    @staticmethod
    async def get_project(db: AsyncSession, project_id: uuid.UUID, user_id: str):
        result = await db.execute(
            select(Project).where(Project.id == project_id, Project.user_id == user_id)
        )
        return result.scalar_one_or_none()
