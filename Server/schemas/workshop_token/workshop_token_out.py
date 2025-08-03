from pydantic import BaseModel, Field
from datetime import datetime
from typing import Optional

class WorkshopTokenOut(BaseModel):
    id: int
    id_workshop: int
    token: str
    id_professor: int
    expiration_at: datetime
    created_at: datetime
    used_at: Optional[datetime] = None
    created_by: int
    is_used: bool
    # Datos relacionados
    workshop_name: str
    professor_name: str
    professor_email: str
    created_by_name: str 