from pydantic import BaseModel, Field
from typing import Optional
from utils.constants import MAX_LENGTH_NAME, MAX_LENGTH_DESCRIPTION, MAX_LENGTH_NOTIFICATION_TYPE
from datetime import datetime

class NotificationOut(BaseModel):
    id_notification: int
    id_user: int
    user_name: str = Field(..., max_length=MAX_LENGTH_NAME)
    user_full_name: str = Field(..., max_length=MAX_LENGTH_NAME)
    user_campus: str = Field(..., max_length=MAX_LENGTH_NAME)
    notification_type: str = Field(..., max_length=MAX_LENGTH_NOTIFICATION_TYPE)
    message: str = Field(..., max_length=MAX_LENGTH_DESCRIPTION)
    is_read: bool
    is_sent: bool
    id_notification_related_table: Optional[int] = None
    related_table_name: Optional[str] = None
    created_at: Optional[datetime] = None
    read_at: Optional[datetime] = None
    sent_at: Optional[datetime] = None
    user_type: Optional[str] = None
    minutes_ago: Optional[int] = None
    hours_ago: Optional[int] = None
    days_ago: Optional[int] = None 