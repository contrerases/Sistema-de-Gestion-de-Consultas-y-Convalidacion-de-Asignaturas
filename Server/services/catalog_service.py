from fastapi import HTTPException
import mariadb
from crud.catalog import (
    get_convalidation_types,
    get_convalidation_states,
    get_workshop_states,
    get_curriculum_course_types
)

def get_convalidation_types_service():
    """Obtiene los tipos de convalidación"""
    try:
        return get_convalidation_types()
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_convalidation_states_service():
    """Obtiene los estados de convalidación"""
    try:
        return get_convalidation_states()
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_workshop_states_service():
    """Obtiene los estados de talleres"""
    try:
        return get_workshop_states()
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_curriculum_course_types_service():
    """Obtiene los tipos de cursos curriculares"""
    try:
        return get_curriculum_course_types()
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e)) 