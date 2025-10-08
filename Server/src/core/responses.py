"""
Modelos de respuesta estandarizados para la API
Sistema: SGSCT
"""
from typing import Any, Optional, Generic, TypeVar, List
from pydantic import BaseModel, Field

T = TypeVar('T')


# =============================================================================
# SCHEMAS DE RESPUESTA (para documentación OpenAPI y tipado)
# =============================================================================

class SuccessResponse(BaseModel, Generic[T]):
    """Schema para respuestas exitosas"""
    data: T = Field(description="Datos de la respuesta")
    message: Optional[str] = Field(default=None, description="Mensaje descriptivo opcional")
    
    model_config = {
        "json_schema_extra": {
            "example": {
                "data": {"id": 1, "name": "Ejemplo"},
                "message": "Operación exitosa"
            }
        }
    }


class ErrorDetail(BaseModel):
    """Detalle de un error individual"""
    field: Optional[str] = Field(default=None, description="Campo que causó el error")
    message: str = Field(description="Mensaje del error")
    code: Optional[str] = Field(default=None, description="Código de error específico")
    
    model_config = {
        "json_schema_extra": {
            "example": {
                "field": "email",
                "message": "El email ya está registrado",
                "code": "DUPLICATE_EMAIL"
            }
        }
    }


class ErrorResponse(BaseModel):
    """Schema para respuestas de error"""
    error: dict = Field(description="Información del error")
    
    model_config = {
        "json_schema_extra": {
            "example": {
                "error": {
                    "code": "VALIDATION_ERROR",
                    "message": "Datos inválidos",
                    "details": [
                        {"field": "email", "message": "Email inválido"}
                    ]
                }
            }
        }
    }


class PaginationMeta(BaseModel):
    """Metadata de paginación"""
    page: int = Field(description="Página actual")
    page_size: int = Field(description="Elementos por página")
    total: int = Field(description="Total de elementos")
    total_pages: int = Field(description="Total de páginas")
    
    model_config = {
        "json_schema_extra": {
            "example": {
                "page": 1,
                "page_size": 20,
                "total": 95,
                "total_pages": 5
            }
        }
    }


class PaginatedResponse(BaseModel, Generic[T]):
    """Schema para respuestas paginadas"""
    data: List[T] = Field(description="Lista de elementos")
    meta: PaginationMeta = Field(description="Metadata de paginación")
    message: Optional[str] = Field(default=None, description="Mensaje opcional")
    
    model_config = {
        "json_schema_extra": {
            "example": {
                "data": [{"id": 1}, {"id": 2}],
                "meta": {
                    "page": 1,
                    "page_size": 20,
                    "total": 95,
                    "total_pages": 5
                }
            }
        }
    }


# =============================================================================
# HELPERS PARA CONSTRUIR RESPUESTAS
# =============================================================================

def success_response(
    data: Any,
    message: Optional[str] = None
) -> dict:
    """
    Construye una respuesta exitosa estandarizada
    
    Args:
        data: Datos a retornar
        message: Mensaje descriptivo opcional
    
    Returns:
        Diccionario con estructura estandarizada
    """
    response = {"data": data}
    if message:
        response["message"] = message
    return response


def error_response(
    code: str,
    message: str,
    details: Optional[List[dict]] = None
) -> dict:
    """
    Construye una respuesta de error estandarizada
    
    Args:
        code: Código de error (ej: VALIDATION_ERROR, NOT_FOUND)
        message: Mensaje legible del error
        details: Lista de detalles adicionales (campo, mensaje)
    
    Returns:
        Diccionario con estructura de error
    """
    error_data = {
        "code": code,
        "message": message
    }
    if details:
        error_data["details"] = details
    
    return {"error": error_data}


def paginated_response(
    data: List[Any],
    page: int,
    page_size: int,
    total: int,
    message: Optional[str] = None
) -> dict:
    """
    Construye una respuesta paginada estandarizada
    
    Args:
        data: Lista de elementos
        page: Página actual (1-indexed)
        page_size: Elementos por página
        total: Total de elementos
        message: Mensaje opcional
    
    Returns:
        Diccionario con estructura paginada
    """
    total_pages = (total + page_size - 1) // page_size if page_size > 0 else 0
    
    response = {
        "data": data,
        "meta": {
            "page": page,
            "page_size": page_size,
            "total": total,
            "total_pages": total_pages
        }
    }
    
    if message:
        response["message"] = message
    
    return response