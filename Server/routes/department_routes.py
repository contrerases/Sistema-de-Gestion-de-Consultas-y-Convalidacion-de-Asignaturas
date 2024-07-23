
from fastapi import HTTPException, status, APIRouter
from models import departments_model
from database import get_db_connection
from typing import List
import mariadb as mdb



router = APIRouter()

BASE_MODEL = departments_model.DepartmentBase
RESPONSE_MODEL = departments_model.DepartmentResponse
POST_MODEL = departments_model.DepartmentPost

@router.get("/departments", response_model=List[RESPONSE_MODEL])
async def get_departments():
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.callproc("GetAllDepartments")
    departments = cursor.fetchall()
    conn.close()
    return departments


#post
@router.post("/departments")
async def add_department(department: POST_MODEL):
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.callproc("InsertDepartment", (department.name,))
        conn.commit()
        cursor.close()
        conn.close()
        return { "message": "Department has been added successfully."}
    except mdb.Error as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))
