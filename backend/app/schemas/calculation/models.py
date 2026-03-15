from pydantic import BaseModel
from typing import Optional, Dict, Any
from uuid import UUID

class SlabCalculationRequest(BaseModel):
    project_id: str
    length: float
    width: float
    thickness: float
    concrete_grade: str
    steel_grade: str
    generate_report: bool = False

class BeamCalculationRequest(BaseModel):
    project_id: str
    length: float
    width: float
    depth: float
    concrete_grade: str
    steel_grade: str
    generate_report: bool = False

class ColumnCalculationRequest(BaseModel):
    project_id: str
    height: float
    width: float
    depth: float
    concrete_grade: str
    steel_grade: str
    generate_report: bool = False

class FootingCalculationRequest(BaseModel):
    project_id: str
    length: float
    width: float
    depth: float
    concrete_grade: str
    steel_grade: str
    generate_report: bool = False

class CalculationResponse(BaseModel):
    id: str
    type: str
    input_data: Dict[str, Any]
    result_data: Dict[str, Any]
    report_url: Optional[str] = None
