from fastapi import APIRouter, status
from typing import List
from schemas.notification.notification_in import NotificationIn
from schemas.notification.notification_out import NotificationOut
from services.notification_service import (
    get_notifications_by_user_service,
    get_notifications_not_read_by_user_service,
    mark_notification_read_service
)

router = APIRouter(prefix="/notifications", tags=["notifications"])

@router.get("/user/{id_auth_user}", response_model=List[NotificationOut])
def get_notifications_by_user(id_auth_user: int):
    """Obtiene notificaciones de un usuario"""
    return get_notifications_by_user_service(id_auth_user)

@router.get("/not-read-user/{id_auth_user}", response_model=List[NotificationOut])
def get_notifications_not_read_by_user(id_auth_user: int):
    """Obtiene notificaciones no leídas de un usuario"""
    return get_notifications_not_read_by_user_service(id_auth_user)

@router.post("/mark-as-read/{id_notification}", response_model=bool)
def mark_notification_read(id_notification: int, id_auth_user: int):
    """Marca una notificación como leída"""
    return mark_notification_read_service(id_notification)

