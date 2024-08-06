from fastapi import HTTPException, status, APIRouter
from models import workshops_model
from database import get_db_connection
from typing import List
import mariadb as mdb

router = APIRouter()

BASE_MODEL = workshops_model.WorkshopBase
POST_MODEL = workshops_model.WorkshopPost
RESPONSE_MODEL = workshops_model.WorkshopResponse

@router.get("/", response_model=List[RESPONSE_MODEL])
async def get_all_workshops():
    try:
        conn = get_db_connection()  #
        cursor = conn.cursor(dictionary=True)
        cursor.callproc("GetAllWorkshops")
        workshops = cursor.fetchall()
        cursor.close()
        conn.close()
        return workshops
    except mdb.Error as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))
    



#post
@router.post("/")
async def insert_workshop(workshop: POST_MODEL):
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.callproc("InsertWorkshop", (workshop.name,))
        conn.commit()
        cursor.close()
        conn.close()
    except mdb.Error as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))
    return {"message": "Workshop has been inserted successfully."}

#GetWorkshopsByAvailable(BOOL available)
@router.get("/available/{available}", response_model=List[RESPONSE_MODEL])
async def get_workshops_by_available(available: bool):
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.callproc("GetWorkshopsByAvailable", (available,))
        workshops = cursor.fetchall()
        cursor.close()
        conn.close()
        return workshops
    except mdb.Error as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))
    
#GetWorkshopsByCurrentlySemester(YEAR, SEMESTER : STR)
@router.get("/semester/{year}/{semester}", response_model=List[RESPONSE_MODEL])
async def get_workshops_by_semester(year: int, semester: str):
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.callproc("GetWorkshopsByCurrentlySemester", (year, semester))
        workshops = cursor.fetchall()
        cursor.close()
        conn.close()
        return workshops
    except mdb.Error as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))
    
#InsertWorkshop
@router.post("/")
async def insert_workshop(workshop: POST_MODEL):
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.callproc("InsertWorkshop", (workshop.name, workshop.semester, workshop.year, workshop.initial_date, workshop.file_data, workshop.available))
        conn.commit()
        cursor.close()
        conn.close()
    except mdb.Error as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))
    return {"message": "Workshop has been inserted successfully."}

#UpdateWorkshopAvailable
@router.put("/available/{id}")
async def update_workshop_available(id: int, available: bool):
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.callproc("UpdateWorkshopAvailable", (id, available))
        conn.commit()
        cursor.close()
        conn.close()
    except mdb.Error as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))
    return {"message": "Workshop has been updated successfully."}

