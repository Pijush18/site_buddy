from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from app.db.models import Calculation
from app.schemas.calculation_schema import CalculationCreate
from uuid import UUID
from typing import List

class CalculationService:
    async def create_calculation(
        self, db: AsyncSession, calculation_in: CalculationCreate
    ) -> Calculation:
        db_calculation = Calculation(
            id=calculation_in.id,
            project_id=calculation_in.project_id,
            type=calculation_in.type,
            input_data=calculation_in.input_data,
            result_data=calculation_in.result_data,
            created_at=calculation_in.created_at
        )
        db.add(db_calculation)
        await db.commit()
        await db.refresh(db_calculation)
        return db_calculation

    async def get_calculations_by_project(
        self, db: AsyncSession, project_id: UUID
    ) -> List[Calculation]:
        result = await db.execute(
            select(Calculation).where(Calculation.project_id == project_id)
        )
        return result.scalars().all()
