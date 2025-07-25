from fastapi import APIRouter, status
from typing import List
from schemas.notification.notification_in import NotificationIn
from schemas.notification.notification_out import NotificationOut

from services.notification_service import (
    create_notification_service,
    get_notifications_service,
    mark_notification_read_service,
    get_notifications_not_read_by_id_user_service
)

router = APIRouter(prefix="/notifications", tags=["notifications"])


@router.get("/", response_model=List[NotificationOut])
def get_notifications_by_user(id_user: int):
    return get_notifications_service(id_user)

@router.get("/not-read-by-user/{id_user}", response_model=List[NotificationOut])
def get_notifications_not_read_by_user(id_user: int):
    return get_notifications_not_read_by_id_user_service(id_user)

@router.post("/mark-as-read/{id_notification}", response_model=bool)
def mark_notification_read(id_notification: int, id_user: int):
    return mark_notification_read_service(id_notification, id_user)

