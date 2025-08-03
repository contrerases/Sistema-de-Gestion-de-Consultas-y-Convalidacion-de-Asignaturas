from fastapi import HTTPException
import mariadb
from crud.professor import (
    # Funciones Preview
    get_professors_active,
    # Funciones Complete
    get_professor_by_id,
    create_professor,
    update_professor
)
from schemas.professor.professor_out import ProfessorOut
from schemas.professor.professor_in import ProfessorIn

# =============================================================================
# SERVICIOS PREVIEW (datos mínimos para listas)
# =============================================================================

def get_all_professors_active_service():
    """Obtiene lista de profesores activos"""
    try:
        rows = get_professors_active()
        return [ProfessorOut(**row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

# =============================================================================
# SERVICIOS COMPLETE (datos completos para detalles)
# =============================================================================

def get_professor_by_id_service(id_professor: int):
    """Obtiene un profesor específico por ID"""
    try:
        result = get_professor_by_id(id_professor)
        if not result:
            raise HTTPException(status_code=404, detail="Profesor no encontrado")
        return ProfessorOut(**result)
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def create_professor_service(professor: ProfessorIn):
    """Crea un nuevo profesor"""
    try:
        return create_professor(professor.name, professor.email)
    except mariadb.Error as e:
        raise HTTPException(status_code=400, detail=str(e))

def update_professor_service(id_professor: int, professor: ProfessorIn):
    """Actualiza un profesor existente"""
    try:
        return update_professor(id_professor, professor.name, professor.email)
    except mariadb.Error as e:
        raise HTTPException(status_code=400, detail=str(e)) 