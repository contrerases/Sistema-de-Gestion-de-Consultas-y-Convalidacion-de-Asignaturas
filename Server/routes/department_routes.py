
from fastapi import HTTPException, status, APIRouter
from models import departments_model
from database import get_db_connection
from typing import List
import mariadb as mdb



router = APIRouter()

BASE_MODEL = departments_model.DepartmentBase
RESPONSE_MODEL = departments_model.DepartmentResponse
POST_MODEL = departments_model.DepartmentPost

@router.get("/", response_model=List[RESPONSE_MODEL])
async def get_all_departments():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.callproc("GetAllDepartments")
    departments = cursor.fetchall()
    conn.close()
    return departments


#post
@router.post("/")
async def insert_department(department: POST_MODEL):
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.callproc("InsertDepartment", (department.name,))
        conn.commit()
        cursor.close()
        conn.close()
        return { "message": "Department has been added successfully."}
    except mdb.Error as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))
    
#put
@router.put("/{id}")
async def update_department(id: int, department: BASE_MODEL):
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.callproc("UpdateDepartmentByID", (id, department.name))
        conn.commit()
        cursor.close()
        conn.close()
        return { "message": "Department has been updated successfully."}
    except mdb.Error as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))
