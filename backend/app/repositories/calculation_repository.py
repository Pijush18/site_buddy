from typing import List
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession
from app.models.calculation_history import CalculationHistory
from app.repositories.base_repository import BaseRepository

class CalculationRepository(BaseRepository[CalculationHistory]):
    def __init__(self, db: AsyncSession):
        super().__init__(CalculationHistory, db)

    async def get_by_user(self, user_id: str, skip: int = 0, limit: int = 20) -> List[CalculationHistory]:
        query = (
            select(self.model)
            .where(self.model.user_id == user_id)
            .order_by(self.model.created_at.desc())
            .offset(skip)
            .limit(limit)
        )
        result = await self.db.execute(query)
        return result.scalars().all()

    async def get_by_project(self, project_id: str, skip: int = 0, limit: int = 20) -> List[CalculationHistory]:
        query = (
            select(self.model)
            .where(self.model.project_id == project_id)
            .order_by(self.model.created_at.desc())
            .offset(skip)
            .limit(limit)
        )
        result = await self.db.execute(query)
        return result.scalars().all()
