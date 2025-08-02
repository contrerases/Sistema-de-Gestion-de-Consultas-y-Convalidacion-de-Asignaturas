from pydantic import BaseModel, Field
from datetime import datetime

class NotificationPreview(BaseModel):
    id_notification: int
    id_user: int
    notification_type: str
    message: str
    is_read: bool
    created_at: datetime
    minutes_ago: int 