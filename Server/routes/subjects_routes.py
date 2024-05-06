from fastapi import HTTPException, status, APIRouter
from models import subjects_model
from database import get_db_connection
from typing import List
import mariadb as mdb

router = APIRouter()

BASE_MODEL = subjects_model.SubjectBase
RESPONSE_MODEL = subjects_model.SubjectResponse
POST_MODEL = subjects_model.SubjectPost

@router.get("/", response_model=List[RESPONSE_MODEL])
async def get_all_subjects():
    try:
        conn = get_db_connection() 
        cursor = conn.cursor(dictionary=True)
        cursor.execute("CALL GetAllSubjectsProcessedData")
        subjects = cursor.fetchall()
        cursor.close()
        conn.close()
        return subjects
    except mdb.Error as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))
    

#delete
@router.delete("/{subject_id}")
async def delete_subject(subject_id: int):
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("CALL DeleteSubjectById(?)", (subject_id,))
        conn.commit()
        cursor.close()
        conn.close()
    except mdb.Error as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))
    return {"message": "Subject has been deleted successfully."}

#post 
@router.post("/")
async def add_subject(subject: POST_MODEL):
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("CALL InsertSubject(?, ?, ?, ?)", (subject.acronym,subject.name ,subject.id_department, subject.credits))
        conn.commit()
        cursor.close()
        conn.close()
        return { "message": "Subject has been added successfully."}
    except mdb.Error as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))