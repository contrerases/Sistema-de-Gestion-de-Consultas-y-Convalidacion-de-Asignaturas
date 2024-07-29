from fastapi import HTTPException, status, APIRouter
from models import types_convalidations_model
from database import get_db_connection
from typing import List
import mariadb as mdb

router = APIRouter()

BASE_MODEL = types_convalidations_model.TypeConvaldiationsBase
RESPONSE_MODEL = types_convalidations_model.TypeConvaldiationsResponse

@router.get("/", response_model=List[RESPONSE_MODEL])
async def get_all_types_convalidations():
    try:
        conn = get_db_connection()  #
        cursor = conn.cursor(dictionary=True)
        cursor.callproc("GetAllTypesConvalidations")
        types_convalidations = cursor.fetchall()
        cursor.close()
        conn.close()
        return types_convalidations
    except mdb.Error as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))
    

