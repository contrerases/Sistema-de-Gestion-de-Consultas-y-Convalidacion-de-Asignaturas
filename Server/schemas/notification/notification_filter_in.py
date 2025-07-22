from pydantic import BaseModel
from typing import Optional

class NotificationFilterIn(BaseModel):
    id_user: Optional[int] = None
    notification_type: Optional[str] = None
    is_read: Optional[bool] = None
    is_sent: Optional[bool] = None
    user_type: Optional[str] = None
    limit: Optional[int] = None 