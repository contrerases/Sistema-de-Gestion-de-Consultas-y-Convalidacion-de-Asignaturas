from pydantic import BaseModel, Field
from typing import Optional
from utils.constants import MAX_LENGTH_NAME, MAX_LENGTH_DESCRIPTION, MAX_LENGTH_NOTIFICATION_TYPE
from datetime import datetime

class NotificationOut(BaseModel):
    id_notification: int
    id_auth_user: int
    notification_type: str = Field(..., max_length=MAX_LENGTH_NOTIFICATION_TYPE)
    message: str = Field(..., max_length=MAX_LENGTH_DESCRIPTION)
    is_read: bool
    created_at: Optional[datetime] = None
    user_type: Optional[str] = None
    limit: Optional[int] = None 