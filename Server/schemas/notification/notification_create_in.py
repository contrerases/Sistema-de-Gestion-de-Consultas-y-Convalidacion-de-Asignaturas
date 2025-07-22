from pydantic import BaseModel, Field
from utils.constants import MAX_LENGTH_NOTIFICATION_TYPE, MAX_LENGTH_DESCRIPTION

class NotificationCreateIn(BaseModel):
    user_type: str = Field(..., max_length=20)
    notification_type: str = Field(..., max_length=MAX_LENGTH_NOTIFICATION_TYPE)
    message: str = Field(..., max_length=MAX_LENGTH_DESCRIPTION) 