from fastapi import APIRouter, Depends, HTTPException, Body
from sqlalchemy.orm import Session
from app.core.database import get_db
from app.models.calculation_history import CalculationHistory, CalculationType
from app.models.report import Report as ReportModel
from app.schemas.calculation.models import (
    SlabCalculationRequest, BeamCalculationRequest, 
    ColumnCalculationRequest, FootingCalculationRequest,
    CalculationResponse
)
from app.services.calculations import slab_service, beam_service, column_service, footing_service
from app.services.pdf_service import PDFReportGenerator
from app.core.google_drive import upload_file_to_drive
from typing import List
import uuid
import os

router = APIRouter()
pdf_generator = PDFReportGenerator()

def record_history(db: Session, user_id: str, calc_type: str, input_data: dict, result_data: dict):
    history = CalculationHistory(
        id=str(uuid.uuid4()),
        user_id=user_id,
        type=calc_type,
        input_data=input_data,
        result_data=result_data
    )
    db.add(history)
    db.commit()
    db.refresh(history)
    return history

def handle_report(db: Session, user_id: str, project_id: str, calc_type: str, input_data: dict, result_data: dict):
    temp_pdf = pdf_generator.generate_calculation_report(calc_type, input_data, result_data)
    try:
        drive_result = upload_file_to_drive(temp_pdf)
        report = ReportModel(
            id=str(uuid.uuid4()),
            user_id=user_id,
            project_id=project_id,
            file_id=drive_result["file_id"],
            file_name=drive_result["file_name"]
        )
        db.add(report)
        db.commit()
        return drive_result["file_url"]
    finally:
        if os.path.exists(temp_pdf):
            os.remove(temp_pdf)

@router.post("/slab", response_model=CalculationResponse)
def calc_slab(request: SlabCalculationRequest, user_id: str = "test-user", db: Session = Depends(get_db)):
    result = slab_service.calculate_slab(request.length, request.width, request.thickness, request.concrete_grade, request.steel_grade)
    history = record_history(db, user_id, "slab", request.dict(), result)
    
    report_url = None
    if request.generate_report:
        report_url = handle_report(db, user_id, request.project_id, "slab", request.dict(), result)
        
    return CalculationResponse(
        id=history.id,
        type="slab",
        input_data=request.dict(),
        result_data=result,
        report_url=report_url
    )

@router.post("/beam", response_model=CalculationResponse)
def calc_beam(request: BeamCalculationRequest, user_id: str = "test-user", db: Session = Depends(get_db)):
    result = beam_service.calculate_beam(request.length, request.width, request.depth, request.concrete_grade, request.steel_grade)
    history = record_history(db, user_id, "beam", request.dict(), result)
    
    report_url = None
    if request.generate_report:
        report_url = handle_report(db, user_id, request.project_id, "beam", request.dict(), result)
        
    return CalculationResponse(
        id=history.id,
        type="beam",
        input_data=request.dict(),
        result_data=result,
        report_url=report_url
    )

@router.post("/column", response_model=CalculationResponse)
def calc_column(request: ColumnCalculationRequest, user_id: str = "test-user", db: Session = Depends(get_db)):
    result = column_service.calculate_column(request.height, request.width, request.depth, request.concrete_grade, request.steel_grade)
    history = record_history(db, user_id, "column", request.dict(), result)
    
    report_url = None
    if request.generate_report:
        report_url = handle_report(db, user_id, request.project_id, "column", request.dict(), result)
        
    return CalculationResponse(
        id=history.id,
        type="column",
        input_data=request.dict(),
        result_data=result,
        report_url=report_url
    )

@router.post("/footing", response_model=CalculationResponse)
def calc_footing(request: FootingCalculationRequest, user_id: str = "test-user", db: Session = Depends(get_db)):
    result = footing_service.calculate_footing(request.length, request.width, request.depth, request.concrete_grade, request.steel_grade)
    history = record_history(db, user_id, "footing", request.dict(), result)
    
    report_url = None
    if request.generate_report:
        report_url = handle_report(db, user_id, request.project_id, "footing", request.dict(), result)
        
    return CalculationResponse(
        id=history.id,
        type="footing",
        input_data=request.dict(),
        result_data=result,
        report_url=report_url
    )
