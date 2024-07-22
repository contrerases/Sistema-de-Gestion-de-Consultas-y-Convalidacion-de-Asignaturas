from fastapi import HTTPException, status, APIRouter
import base64
from models import requests_model

from typing import List


import mariadb as mdb
from database import get_db_connection

BASE_MODEL = requests_model.Request
RESPONSE_MODEL = requests_model.RequestResponse

router = APIRouter()


@router.get("/", response_model=List[RESPONSE_MODEL])
async def get_all_requests():
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)

        # Obtener todas las solicitudes
        cursor.callproc("GetAllRequestsProcessed")
        requests = cursor.fetchall()

        for request in requests:
            request_id = request['id']

            # Obtener convalidaciones para cada solicitud
            cursor.callproc("GetConvalidationsByRequestID", (request_id,))
            convalidations = cursor.fetchall()

            # Mapear nombres de campos
            for convalidation in convalidations:
                pdf_content = convalidation.pop('file_data', None)
                if pdf_content:
                    # Convertir el archivo a Base64
                    convalidation['file_data'] = base64.b64encode(
                        pdf_content).decode('utf-8')

            # Añadir convalidaciones a la solicitud
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


@router.post("/", response_model=BASE_MODEL)
async def insert_request(request: BASE_MODEL):
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

        return request
    except mdb.Error as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))
