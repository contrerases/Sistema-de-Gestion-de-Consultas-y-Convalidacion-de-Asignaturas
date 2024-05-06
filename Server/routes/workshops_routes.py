from fastapi import HTTPException, status, APIRouter
from models import workshops_model
from database import get_db_connection
from typing import List
import mariadb as mdb

router = APIRouter()

BASE_MODEL = workshops_model.WorkshopBase
POST_MODEL = workshops_model.WorkshopPost

@router.get("/", response_model=List[BASE_MODEL])
async def get_all_workshops():
    try:
        conn = get_db_connection()  #
        cursor = conn.cursor(dictionary=True)
        cursor.execute("CALL GetAllWorkshops")
        workshops = cursor.fetchall()
        cursor.close()
        conn.close()
        return workshops
    except mdb.Error as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))
    

#delete
@router.delete("/{workshop_id}")
async def delete_workshop(workshop_id: int):
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("CALL DeleteWorkshopById(?)", (workshop_id,))
        conn.commit()
        cursor.close()
        conn.close()
    except mdb.Error as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))
    return {"message": "Workshop has been deleted successfully."}

#post
@router.post("/")
async def insert_workshop(workshop: POST_MODEL):
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("CALL InsertWorkshop(?)", (workshop.name,))
        conn.commit()
        cursor.close()
        conn.close()
    except mdb.Error as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))
    return {"message": "Workshop has been inserted successfully."}