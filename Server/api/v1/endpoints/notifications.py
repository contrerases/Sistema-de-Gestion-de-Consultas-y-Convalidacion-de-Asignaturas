from fastapi import APIRouter, status
from typing import List
from schemas.notification.notification_in import NotificationIn
from schemas.notification.notification_out import NotificationOut
from schemas.notification.notification_filter_in import NotificationFilterIn
from services.notification_service import (
    create_notification_service,
    get_notifications_service,
    mark_notification_read_service
)

router = APIRouter(prefix="/notifications", tags=["notifications"])

@router.post("/", response_model=bool, status_code=status.HTTP_201_CREATED)
def create_notification(notification: NotificationIn):
    return create_notification_service(notification)

@router.post("/filter", response_model=List[NotificationOut])
def filter_notifications(filters: NotificationFilterIn):
    return get_notifications_service(filters)

@router.put("/mark-read/", response_model=bool)
def mark_notification_read(id_notification: int, id_user: int):
    return mark_notification_read_service(id_notification, id_user) 