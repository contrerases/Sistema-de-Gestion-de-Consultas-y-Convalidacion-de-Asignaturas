from fastapi import HTTPException, status, APIRouter, Form, UploadFile
from typing import List, Optional

import mariadb as mdb
from database import get_db_connection

from models import convalidations_model
from datetime import datetime
import base64



router = APIRouter()

BASE_MODEL = convalidations_model.ConvalidationBase
RESPONSE_MODEL = convalidations_model.ConvalidationResponse
UPDATE_MODEL = convalidations_model.ConvalidationUpdate



# Endpoint para obtener todas las convalidaciones
@router.get("/", response_model=List[RESPONSE_MODEL])
async def get_all_convalidations():
    try:
        conn = get_db_connection()  
        cursor = conn.cursor(dictionary=True)
        cursor.execute("CALL GetAllConvalidationsProcessedData")
        convalidations = cursor.fetchall()

      
        for convalidation in convalidations:
            pdf_content = convalidation.pop('file_data', None)
            if pdf_content:
                convalidation['file_data'] = base64.b64encode(pdf_content).decode('utf-8')

        cursor.close()
        conn.close()  
        return convalidations
    except mdb.Error as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))
    


@router.get("/state/{state}", response_model=List[RESPONSE_MODEL])
async def get_convalidations_by_state(state: str):
    try:
        conn = get_db_connection()  
        cursor = conn.cursor(dictionary=True)
        cursor.execute("CALL GetConvalidationsByState(%s)", (state,))
        convalidations = cursor.fetchall()

        for convalidation in convalidations:
            pdf_content = convalidation.pop('file_data', None)
            if pdf_content:
                convalidation['file_data'] = base64.b64encode(pdf_content).decode('utf-8')

        cursor.close()
        conn.close()  
        return convalidations
    except mdb.Error as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))
    
#getbyid

@router.get("/{id}", response_model=RESPONSE_MODEL)
async def get_convalidation_by_id(id: int):
    try:
        conn = get_db_connection()  
        cursor = conn.cursor(dictionary=True)
        cursor.execute("CALL GetConvalidationById(%s)", (id,))
        convalidation = cursor.fetchone()

        if not convalidation:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Convalidation not found")

        pdf_content = convalidation.pop('file_data', None)
        if pdf_content:
            convalidation['file_data'] = base64.b64encode(pdf_content).decode('utf-8')

        cursor.close()
        conn.close()  
        return convalidation
    except mdb.Error as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))
    
    

@router.post("/")
async def insert_convalidation(
    id_student: int = Form(...),
    id_convalidation_type: int = Form(...),
    creation_date: Optional[datetime] = Form(None),
    revision_date: Optional[datetime] = Form(None),
    id_user_approves: Optional[int] = Form(None),
    id_curriculum_course: Optional[int] = Form(...),
    id_subject_to_convalidate: Optional[int] = Form(None),
    id_workshop_to_convalidate: Optional[int] = Form(None),
    certified_course_name: Optional[str] = Form(None),
    personal_project_name: Optional[str] = Form(None),
    file_data: Optional[UploadFile] = Form(None),
    file_name: Optional[str] = Form(None)
):
    try:
        conn = get_db_connection() 
        cursor = conn.cursor(dictionary=True)

        if file_data:
            file_data_content = await file_data.read()
            file_name = file_data.filename
        else:
            file_data_content = None
            file_name = None

        cursor.execute(
            "CALL InsertConvalidation(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)",
            (
                id_student,
                id_convalidation_type,
                id_user_approves,
                id_curriculum_course,
                id_subject_to_convalidate,
                id_workshop_to_convalidate,
                certified_course_name,
                personal_project_name,
                file_data_content,
                file_name,
                creation_date,
                revision_date
            )
        )
        conn.commit() 
        cursor.close()
        conn.close()

        return {"message": "Convalidación creada correctamente"}
    except mdb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))
    

#put

@router.put("/")
async def update_convalidation(convalidation: UPDATE_MODEL):
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("CALL ModifyConvalidation(%s, %s, %s)", (convalidation.id, convalidation.state, convalidation.comments))
        conn.commit()
        cursor.close()
        conn.close()
        return {"message": "Convalidación actualizada correctamente"}
    except mdb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))
    

