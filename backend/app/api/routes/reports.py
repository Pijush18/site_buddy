from fastapi import APIRouter, Depends, HTTPException, UploadFile, File, Form
from sqlalchemy.orm import Session
from app.core.database import get_db
from app.models.report import Report as ReportModel
from app.schemas.report_schema import Report as ReportSchema
from app.core.google_drive import upload_file_to_drive
import shutil
import os
import uuid
from typing import List

router = APIRouter()

@router.post("/upload", response_model=ReportSchema)
def upload_report(
    project_id: str = Form(...),
    user_id: str = Form(...), # Minimal auth for now as requested
    file: UploadFile = File(...),
    db: Session = Depends(get_db)
):
    temp_file_path = f"/tmp/{file.filename}"
    try:
        # 1. Save uploaded file to temporary location
        with open(temp_file_path, "wb") as buffer:
            shutil.copyfileobj(file.file, buffer)
        
        # 2. Upload to Google Drive
        drive_result = upload_file_to_drive(temp_file_path)
        
        # 3. Store metadata in PostgreSQL
        report = ReportModel(
            id=str(uuid.uuid4()),
            user_id=user_id,
            project_id=project_id,
            file_id=drive_result["file_id"],
            file_name=drive_result["file_name"],
        )
        db.add(report)
        db.commit()
        db.refresh(report)
        
        # 4. Prepare response
        return ReportSchema(
            id=uuid.UUID(report.id),
            project_id=uuid.UUID(report.project_id),
            file_id=report.file_id,
            file_name=report.file_name,
            file_url=drive_result["file_url"],
            created_at=report.created_at
        )
        
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        # Cleanup temp file
        if os.path.exists(temp_file_path):
            os.remove(temp_file_path)

@router.get("/project/{project_id}", response_model=List[ReportSchema])
def list_project_reports(
    project_id: str, 
    db: Session = Depends(get_db)
):
    reports = db.query(ReportModel).filter(ReportModel.project_id == project_id).all()
    return [
        ReportSchema(
            id=uuid.UUID(r.id),
            project_id=uuid.UUID(r.project_id),
            file_id=r.file_id,
            file_name=r.file_name,
            created_at=r.created_at
        ) for r in reports
    ]
