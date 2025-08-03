from fastapi import HTTPException
import mariadb
from crud.student import (
    get_students,
    get_student_by_rut,
    get_student_by_name,
    get_student_by_rol,
    get_student_by_id,
    create_student,
    update_student,
    delete_student
)
from schemas.student.student_in import StudentIn
from schemas.student.student_out import StudentOut

# =============================================================================
# SERVICIOS DE ESTUDIANTES
# =============================================================================

def get_all_students_service():
    """Obtiene lista de estudiantes con datos mínimos para preview"""
    try:
        rows = get_students()
        return [StudentOut(**row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_student_by_rut_service(rut_student: str):
    """Obtiene un estudiante por RUT con datos mínimos"""
    try:
        result = get_student_by_rut(rut_student)
        return StudentOut(**result) if result else None
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_student_by_name_service(first_names: str):
    """Obtiene estudiantes por nombre con datos mínimos"""
    try:
        rows = get_student_by_name(first_names)
        return [StudentOut(**row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_student_by_rol_service(rol_student: str):
    """Obtiene un estudiante por ROL con datos mínimos"""
    try:
        result = get_student_by_rol(rol_student)
        return StudentOut(**result) if result else None
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_student_by_id_service(id_student: int):
    """Obtiene un estudiante específico por ID con datos completos"""
    try:
        result = get_student_by_id(id_student)
        return StudentOut(**result) if result else None
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def create_student_service(student: StudentIn):
    """Crea un nuevo estudiante"""
    try:
        return create_student(
            student.first_names, 
            student.last_names, 
            student.campus, 
            student.rol_student, 
            student.rut_student, 
            student.campus_student, 
            student.email, 
            student.password
        )
    except mariadb.Error as e:
        raise HTTPException(status_code=400, detail=str(e))

def update_student_service(id_student: int, student: StudentIn):
    """Actualiza un estudiante existente"""
    try:
        return update_student(
            id_student, 
            student.first_names, 
            student.last_names, 
            student.campus, 
            student.rol_student, 
            student.rut_student, 
            student.campus_student, 
            student.email, 
            student.password
        )
    except mariadb.Error as e:
        raise HTTPException(status_code=400, detail=str(e))

def delete_student_service(id_student: int):
    """Elimina un estudiante"""
    try:
        return delete_student(id_student)
    except mariadb.Error as e:
        raise HTTPException(status_code=400, detail=str(e)) 