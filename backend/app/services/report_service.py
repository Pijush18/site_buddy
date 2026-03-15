import os
import shutil
from fastapi import UploadFile
from uuid import UUID, uuid4
from datetime import datetime
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from app.db.models import Report
from typing import List

class StorageService:
    """Mock Storage Service representing R2/S3 functionality."""
    def __init__(self):
        self.upload_dir = "uploads/reports"
        os.makedirs(self.upload_dir, exist_ok=True)

    async def upload_file(self, file: UploadFile, file_id: UUID) -> str:
        file_extension = os.path.splitext(file.filename)[1]
        file_name = f"{file_id}{file_extension}"
        file_path = os.path.join(self.upload_dir, file_name)
        
        with open(file_path, "wb") as buffer:
            shutil.copyfileobj(file.file, buffer)
            
        # In production this would be an S3 URL like:
        # return f"https://storage.sitebuddy.com/reports/{file_name}"
        return f"/uploads/reports/{file_name}"

class ReportService:
    def __init__(self):
        self.storage = StorageService()

    async def create_report(
        self, db: AsyncSession, project_id: UUID, file: UploadFile
    ) -> Report:
        report_id = uuid4()
        
        # 1. Upload to storage
        file_url = await self.storage.upload_file(file, report_id)
        
        # 2. Store metadata in DB
        db_report = Report(
            id=report_id,
            project_id=project_id,
            pdf_url=file_url,
            created_at=datetime.utcnow()
        )
        db.add(db_report)
        await db.commit()
        await db.refresh(db_report)
        return db_report

    async def get_reports_by_project(
        self, db: AsyncSession, project_id: UUID
    ) -> List[Report]:
        result = await db.execute(
            select(Report).where(Report.project_id == project_id)
        )
        return result.scalars().all()
