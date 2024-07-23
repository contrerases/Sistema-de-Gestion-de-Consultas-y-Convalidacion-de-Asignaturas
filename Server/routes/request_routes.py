from fastapi import HTTPException, status, APIRouter
import base64
from models import requests_model

from typing import List


import mariadb as mdb
from database import get_db_connection

BASE_MODEL = requests_model.Request
RESPONSE_MODEL = requests_model.RequestResponse
INSERT_MODEL = requests_model.RequestInsert

router = APIRouter()


@router.get("/", response_model=List[RESPONSE_MODEL])
async def get_all_requests():
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)

    
        cursor.callproc("GetAllRequestsProcessed")
        requests = cursor.fetchall()

        for request in requests:
            request_id = request['id']

            cursor.callproc("GetConvalidationsByRequestID", (request_id,))
            convalidations = cursor.fetchall()

            for convalidation in convalidations:
                pdf_content = convalidation.pop('file_data', None)
                if pdf_content:
                    convalidation['file_data'] = base64.b64encode(pdf_content).decode('utf-8')
        
            request['convalidations'] = convalidations

        cursor.close()
        conn.close()

        return requests
    except mdb.Error as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))


@router.get("/{request_id}", response_model=RESPONSE_MODEL)
async def get_request_by_id(request_id: int):
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)

        cursor.callproc("GetRequestByIDProcessed", (request_id,))
        request = cursor.fetchone()

        cursor.callproc("GetConvalidationsByRequestID", (request_id,))
        convalidations = cursor.fetchall()

        for convalidation in convalidations:
            pdf_content = convalidation.pop('file_data', None)
            if pdf_content:
                convalidation['file_data'] = base64.b64encode(
                    pdf_content).decode('utf-8')

        request['convalidations'] = convalidations

        cursor.close()
        conn.close()

        return request
    except mdb.Error as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))


@router.post("/")
async def insert_request(request: INSERT_MODEL):
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)

        cursor.callproc("InsertRequest", (
            request.id_student,
            request.creation_date,
            request.revision_date,
            request.comments,
            request.id_user_approves,
        ))

        id_request = cursor.fetchone()['id']

        for convalidation in request.convalidations:
            cursor.callproc("InsertConvalidation", (
                id_request,
                convalidation.id_convalidation_type,
                convalidation.state, 
                convalidation.id_curriculum_course, 
                convalidation.id_subject_to_convalidate,
                convalidation.id_workshop_to_convalidate, 
                convalidation.certified_course_name, 
                convalidation.personal_project_name,
                convalidation.file_data, 
                convalidation.file_name))
                                                 

        conn.commit()
        cursor.close()
        conn.close()

        return {"Convalidation Inserted Successfully"}
    except mdb.Error as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))
