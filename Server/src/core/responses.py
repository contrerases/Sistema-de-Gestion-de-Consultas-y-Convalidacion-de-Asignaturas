"""Modelos de respuesta estandarizados para la API SGSCT"""

from typing import Any, Optional, Generic, TypeVar, List
from datetime import datetime
from fastapi.responses import JSONResponse
from pydantic import BaseModel, Field

T = TypeVar('T')

class APIResponseData(BaseModel, Generic[T]):
    """Modelo base para los datos de respuesta"""
    success: bool = Field(description="Indica si la operación fue exitosa")
    message: str = Field(description="Mensaje descriptivo de la operación")
    data: Optional[T] = Field(default=None, description="Datos de respuesta")
    errors: Optional[List[str]] = Field(default=None, description="Lista de errores")
    timestamp: datetime = Field(default_factory=datetime.now, description="Timestamp de la respuesta")
    
    class Config:
        json_encoders = {
            datetime: lambda v: v.isoformat()
        }

class SuccessResponse(JSONResponse):
    """Respuesta para operaciones exitosas"""
    
    def __init__(self, message: str, data: Optional[Any] = None, status_code: int = 200):
        content = APIResponseData(
            success=True,
            message=message,
            data=data,
            errors=None,
            timestamp=datetime.now()
        ).model_dump()
        
        super().__init__(content=content, status_code=status_code)

class ErrorResponse(JSONResponse):
    """Respuesta para errores"""
    
    def __init__(self, message: str, errors: Optional[List[str]] = None, status_code: int = 400):
        content = APIResponseData(
            success=False,
            message=message,
            data=None,
            errors=errors or [message],
            timestamp=datetime.now()
        ).model_dump()
        
        super().__init__(content=content, status_code=status_code)

class ValidationErrorResponse(JSONResponse):
    """Respuesta específica para errores de validación"""
    
    def __init__(self, message: str = "Error de validación", errors: Optional[List[str]] = None, 
                 field_errors: Optional[dict] = None, status_code: int = 422):
        content = APIResponseData(
            success=False,
            message=message,
            data=None,
            errors=errors or [message],
            timestamp=datetime.now()
        ).model_dump()
        
        # Agregar field_errors si existen
        if field_errors:
            content["field_errors"] = field_errors
        
        super().__init__(content=content, status_code=status_code)

class PaginatedResponse(JSONResponse):
    """Respuesta para datos paginados"""
    
    def __init__(self, message: str, data: Any, total: int, page: int, per_page: int, status_code: int = 200):
        total_pages = (total + per_page - 1) // per_page
        
        content = APIResponseData(
            success=True,
            message=message,
            data=data,
            errors=None,
            timestamp=datetime.now()
        ).model_dump()
        
        # Agregar información de paginación en un diccionario separado
        content["pagination"] = {
            "total": total,
            "page": page,
            "per_page": per_page,
            "total_pages": total_pages
        }
        
        super().__init__(content=content, status_code=status_code)