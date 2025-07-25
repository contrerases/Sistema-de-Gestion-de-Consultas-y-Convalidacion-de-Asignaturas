from fastapi import HTTPException
import mariadb
from crud.student import get_students, create_student, update_student, delete_student
from schemas.student.student_in import StudentIn
from schemas.student.student_out import StudentOut

def get_all_students_service():
    try:
        rows = get_students()
        return [StudentOut(**row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_student_by_id_service(id_student: int):
    try:
        rows = get_students(student_id=id_student)
        return StudentOut(**rows[0]) if rows else None
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_student_by_rut_service(rut_student: str):
    try:
        rows = get_students(rut_student=rut_student)
        return StudentOut(**rows[0]) if rows else None
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_student_by_name_service(first_names: str):
    try:
        rows = get_students(first_names=first_names)
        return [StudentOut(**row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_student_by_rol_service(rol_student: str):
    try:
        rows = get_students(rol_student=rol_student)
        return StudentOut(**rows[0]) if rows else None
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def create_student_service(student: StudentIn):
    try:
        return create_student(student.first_names, student.last_names, student.campus, student.rol_student, student.rut_student, student.campus_student, student.email, student.password)
    except mariadb.Error as e:
        raise HTTPException(status_code=400, detail=str(e))

def update_student_service(id_student: int, student: StudentIn):
    try:
        return update_student(id_student, student.first_names, student.last_names, student.campus, student.rol_student, student.rut_student, student.campus_student, student.email, student.password)
    except mariadb.Error as e:
        raise HTTPException(status_code=400, detail=str(e))

def delete_student_service(id_student: int):
    try:
        return delete_student(id_student)
    except mariadb.Error as e:
        raise HTTPException(status_code=400, detail=str(e)) 