from fastapi import HTTPException
import mariadb
from crud.dashboard import get_statistics
 
def get_statistics_service():
    try:
        return get_statistics()
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e)) 