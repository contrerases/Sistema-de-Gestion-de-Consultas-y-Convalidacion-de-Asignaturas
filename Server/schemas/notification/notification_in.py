from pydantic import BaseModel
from typing import Optional

class NotificationIn(BaseModel):
    user_type: Optional[str] = None
    notification_type: str
    message: str 