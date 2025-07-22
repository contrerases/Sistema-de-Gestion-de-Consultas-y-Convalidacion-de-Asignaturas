from fastapi import HTTPException
import mariadb
from crud.student import get_students, create_student, update_student, delete_student
from schemas.student.student_create_in import StudentCreateIn
from schemas.student.student_out import StudentOut
import bcrypt

def get_all_students_service():
    try:
        rows = get_students()
        return [StudentOut(**row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_student_by_id_service(student_id: int):
    try:
        rows = get_students(student_id)
        if not rows:
            raise HTTPException(status_code=404, detail="Estudiante no encontrado")
        return StudentOut(**rows[0])
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def create_student_service(student: StudentCreateIn):
    try:
        password_hash = bcrypt.hashpw(student.password.encode('utf-8'), bcrypt.gensalt()).decode('utf-8')
        return create_student(
            student.first_names,
            student.last_names,
            student.campus,
            student.rol_student,
            student.rut_student,
            student.campus_student,
            student.email,
            password_hash
        )
    except mariadb.Error as e:
        raise HTTPException(status_code=400, detail=str(e))

def update_student_service(student_id: int, student: StudentCreateIn):
    try:
        password_hash = bcrypt.hashpw(student.password.encode('utf-8'), bcrypt.gensalt()).decode('utf-8')
        return update_student(
            student_id,
            student.first_names,
            student.last_names,
            student.campus,
            student.rol_student,
            student.rut_student,
            student.campus_student,
            student.email,
            password_hash
        )
    except mariadb.Error as e:
        raise HTTPException(status_code=400, detail=str(e))

def delete_student_service(student_id: int):
    try:
        return delete_student(student_id)
    except mariadb.Error as e:
        raise HTTPException(status_code=400, detail=str(e)) 