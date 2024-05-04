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




