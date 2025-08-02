from pydantic import BaseModel, Field
from datetime import datetime
from utils.constants import MAX_LENGTH_NAME, MAX_LENGTH_EMAIL

class NotificationOut(BaseModel):
    id_notification: int
    id_user: int
    notification_type: str
    message: str
    is_read: bool
    is_sent: bool
    created_at: datetime
    read_at: datetime | None
    sent_at: datetime | None
    # Datos del usuario
    user_name: str = Field(..., max_length=MAX_LENGTH_NAME)
    user_campus: str
    user_email: str = Field(..., max_length=MAX_LENGTH_EMAIL)
    user_type: str
    # Tiempo transcurrido
    minutes_ago: int
    hours_ago: int
    days_ago: int 