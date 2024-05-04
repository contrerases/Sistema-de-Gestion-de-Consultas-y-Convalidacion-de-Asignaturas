from fastapi import HTTPException, status, APIRouter
from models import convalidations_model
from database import get_db_connection
from typing import List
import mariadb as mdb


router = APIRouter()

BASE_MODEL = convalidations_model.ConvalidationBase
RESPONSE_MODEL = convalidations_model.ConvalidationResponse


# Endpoint para obtener todas las convalidaciones
@router.get("/", response_model=List[RESPONSE_MODEL])
async def get_all_convalidations():
    try:
        conn = get_db_connection()  # Abrir la conexión
        cursor = conn.cursor(dictionary=True)
        cursor.execute("CALL GetAllConvalidationsProcessedData")
        convalidations = cursor.fetchall()
        cursor.close()
        conn.close()  # Cerrar la conexión
        return convalidations
    except mdb.Error as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))

# Endpoint para obtener convalidaciones por estado
@router.get("/state/{state}", response_model=List[RESPONSE_MODEL])
async def get_convalidations_by_state(state: str):
    try:
        conn = get_db_connection()  # Abrir la conexión
        cursor = conn.cursor(dictionary=True)
        cursor.execute("CALL get_convalidation_by_state(?)", (state,))
        convalidations = cursor.fetchall()
        cursor.close()
        conn.close()  # Cerrar la conexión
        return convalidations
    except mdb.Error as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))

# Endpoint para obtener convalidaciones por estudiante
@router.get("/student/{rol}", response_model=List[RESPONSE_MODEL])
async def get_convalidations_by_student(rol: int):
    try:
        conn = get_db_connection()  # Abrir la conexión
        cursor = conn.cursor(dictionary=True)
        cursor.execute("CALL get_convalidation_by_student(?)", (rol,))
        convalidations = cursor.fetchall()
        cursor.close()
        conn.close()  # Cerrar la conexión
        return convalidations
    except mdb.Error as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))
    

@router.put("/set_convalidation/{id}", response_model=BASE_MODEL)
async def set_convalidation(id: int, query: BASE_MODEL):
    try:
        conn = get_db_connection()  
        cursor = conn.cursor(dictionary=True)
        cursor.execute("CALL set_convalidation(?, ?, ?)", (id, query.state, query.comments))
        conn.commit()
        cursor.close()
        conn.close() 
        return query
    except mdb.Error as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))










