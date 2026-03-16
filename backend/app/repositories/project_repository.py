from typing import List, Optional
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from app.models.project import Project
from app.repositories.base_repository import BaseRepository

class ProjectRepository(BaseRepository[Project]):
    def __init__(self, db_session: AsyncSession):
        super().__init__(Project, db_session)

    async def get_by_user(self, user_id: str, skip: int = 0, limit: int = 20) -> List[Project]:
        query = (
            select(self.model)
            .where(self.model.user_id == user_id)
            .order_by(self.model.created_at.desc())
            .offset(skip)
            .limit(limit)
        )
        result = await self.db.execute(query)
        return result.scalars().all()
