from fastapi import HTTPException, status, APIRouter
import base64
from models import requests_model

from typing import List


import mariadb as mdb
from database import get_db_connection

BASE_MODEL = requests_model.Request
RESPONSE_MODEL = requests_model.RequestResponse
INSERT_MODEL = requests_model.RequestInsert
UPDATE_MODEL = requests_model.RequestUpdate
FILTERED_MODEL = requests_model.RequestFiltered

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

        cursor.callproc("GetRequestByID", (request_id,))
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

@router.get("/student/rut/{student_rut}", response_model=List[RESPONSE_MODEL])
async def get_request_by_student_id(student_rut: str):
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)

        cursor.callproc("GetRequestsByStudentRUT", (student_rut,))
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
    

#student_rol

@router.get("/student/rol/{student_rol}", response_model=List[RESPONSE_MODEL])
async def get_request_by_student_rol(student_rol: str):
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)

        cursor.callproc("GetRequestsByStudentROL", (student_rol,))
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

#range creation date

@router.get("/creation_date/{start_date}/{end_date}", response_model=List[RESPONSE_MODEL])
async def get_request_by_range_creation_date(start_date: str, end_date: str):
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)

        cursor.callproc("GetRequestsByDateRangeCreation", (start_date, end_date,))
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
    

#FILTERED 
@router.post("/filtered", response_model=List[RESPONSE_MODEL])
async def get_filtered_requests(filter: FILTERED_MODEL):
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)

        cursor.callproc("GetFilteredRequests", (filter.name_student, filter.rut_student, filter.rol_student, filter.date_lower_bound, filter.date_upper_bound))
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



@router.get("/state/{state}", response_model=List[RESPONSE_MODEL])
async def get_request_by_state(state: str):
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)

        cursor.callproc("GetRequestsByState", (state,))
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




@router.post("/")
async def insert_request(request: INSERT_MODEL):
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)

        cursor.callproc("InsertRequest", (
            request.id_student,
            request.comments,
            request.id_user_approves,
        ))

        id_request = cursor.fetchone()['id']

        for convalidation in request.convalidations:
            file_data_bytes = convalidation.file_data
            if convalidation.file_data:
                file_data_bytes = base64.b64decode(convalidation.file_data)
            
            cursor.callproc("InsertConvalidation", (
                id_request,
                convalidation.id_convalidation_type,
                convalidation.id_curriculum_course, 
                convalidation.id_subject_to_convalidate,
                convalidation.id_workshop_to_convalidate, 
                convalidation.certified_course_name, 
                convalidation.personal_project_name,
                file_data_bytes, 
                convalidation.file_name))
                                                 

        conn.commit()
        cursor.close()
        conn.close()

        return {"Convalidation Inserted Successfully"}
    except mdb.Error as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))





@router.put("/")
async def update_request(request: UPDATE_MODEL):
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)

        print(request)

        cursor.callproc("UpdateRequest", (
            request.id,
            request.comments,
            request.id_user_approver
        ))

        for convalidation in request.convalidations:
            cursor.callproc("UpdateConvalidation", (
                convalidation.id,
                convalidation.state
            ))

        conn.commit()
        cursor.close()
        conn.close()

        return {"Request Updated Successfully"}
    except mdb.Error as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))