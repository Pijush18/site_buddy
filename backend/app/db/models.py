import uuid
from datetime import datetime
from sqlalchemy import Column, String, DateTime, ForeignKey, Integer, JSON, Enum
from sqlalchemy.dialects.postgresql import UUID, JSONB
from sqlalchemy.orm import relationship
from .database import Base

class User(Base):
    __tablename__ = "users"
    
    id = Column(String, primary_key=True) # Firebase UID
    email = Column(String, unique=True, index=True, nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow)
    subscription_status = Column(String, default="free")
    
    projects = relationship("Project", back_populates="user")
    assistant_history = relationship("AssistantHistory", back_populates="user")
    subscription = relationship("Subscription", back_populates="user", uselist=False)

class Project(Base):
    __tablename__ = "projects"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = Column(String, ForeignKey("users.id"))
    name = Column(String, nullable=False)
    location = Column(String)
    description = Column(String)
    created_at = Column(DateTime, default=datetime.utcnow)
    
    user = relationship("User", back_populates="projects")
    calculations = relationship("Calculation", back_populates="project")
    reports = relationship("Report", back_populates="project")

class Calculation(Base):
    __tablename__ = "calculations"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    project_id = Column(UUID(as_uuid=True), ForeignKey("projects.id"))
    type = Column(String, nullable=False) # e.g., 'slab_design', 'concrete_estimate'
    input_data = Column(JSONB, nullable=False)
    result_data = Column(JSONB, nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow)
    
    project = relationship("Project", back_populates="calculations")

class Report(Base):
    __tablename__ = "reports"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    project_id = Column(UUID(as_uuid=True), ForeignKey("projects.id"))
    pdf_url = Column(String, nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow)
    
    project = relationship("Project", back_populates="reports")

class AssistantHistory(Base):
    __tablename__ = "assistant_history"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = Column(String, ForeignKey("users.id"))
    prompt = Column(String, nullable=False)
    response = Column(String, nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow)
    
    user = relationship("User", back_populates="assistant_history")

class Subscription(Base):
    __tablename__ = "subscriptions"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = Column(String, ForeignKey("users.id"), unique=True)
    plan = Column(String, default="free") # 'free', 'premium', 'professional'
    status = Column(String, default="inactive") # 'active', 'expired', 'canceled'
    expiry_date = Column(DateTime, nullable=True)
    last_validated = Column(DateTime, default=datetime.utcnow)
    
    user = relationship("User", back_populates="subscription")
