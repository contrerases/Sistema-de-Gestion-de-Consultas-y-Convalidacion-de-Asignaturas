from fastapi import APIRouter, status, Query
from typing import List
from schemas.notification.notification_in import NotificationIn
from schemas.notification.notification_out import NotificationOut
from schemas.notification.notification_filter_in import NotificationFilterIn
from services.notification_service import (
    create_notification_service,
    get_notifications_service,
    mark_notification_read_service,
    get_notifications_not_read_by_id_user_service
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

@router.get("/not-read/{id_user}", response_model=List[NotificationOut])
def get_notifications_not_read_by_id_user(id_user: int):
    filters = NotificationFilterIn(id_user=id_user, is_read=False)
    return get_notifications_service(filters)