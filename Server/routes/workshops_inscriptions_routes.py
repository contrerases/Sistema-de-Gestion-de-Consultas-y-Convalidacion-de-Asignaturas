from fastapi import HTTPException, status, APIRouter
from models import workshops_inscriptions_model
from database import get_db_connection
from typing import List
import mariadb as mdb

router = APIRouter()

BASE_MODEL = workshops_inscriptions_model.WorkshopsInscriptionsBase
POST_MODEL = workshops_inscriptions_model.WorkshopsInscriptionsPost
RESPONSE_MODEL = workshops_inscriptions_model.WorkshopsInscriptionsResponse

#GetByIdWorkshop
@router.get("/{id}", response_model=List[RESPONSE_MODEL])
async def get_workshop_inscriptions_by_id(id: int):
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.callproc("GetWorkshopsInscriptionsByWorkshopID", (id,))
        workshop_inscription = cursor.fetchall()
        cursor.close()
        conn.close()
        return workshop_inscription
    except mdb.Error as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))

#GetByIdStudent
@router.get("/student/{id_student}", response_model=List[RESPONSE_MODEL])
async def get_workshop_inscriptions_by_student(id_student: int):
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.callproc("GetWorkshopsInscriptionsByStudentID", (id_student,))
        workshop_inscriptions = cursor.fetchall()
        cursor.close()
        conn.close()
        return workshop_inscriptions
    except mdb.Error as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))
 

    

#InsertWorkshopInscription
@router.post("/")
async def insert_workshop_inscription(workshop_inscription: POST_MODEL):
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.callproc("InsertWorkshopInscription", (workshop_inscription.id_student, workshop_inscription.id_workshop,workshop_inscription.id_curriculum_course, workshop_inscription.is_convalidated ))
        conn.commit()
        cursor.close()
        conn.close()
    except mdb.Error as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))
    return {"message": "Workshop inscription has been inserted successfully."}

