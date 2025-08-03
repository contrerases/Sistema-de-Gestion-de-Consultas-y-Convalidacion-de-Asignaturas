from fastapi import HTTPException
import mariadb
from crud.notification import (
    get_notifications,
    get_notifications_by_user,
    get_notifications_not_read_by_user,
    get_notification_by_id,
    create_notification,
    mark_notification_read
)
from schemas.notification.notification_in import NotificationIn
from schemas.notification.notification_out import NotificationOut
from typing import Optional

# =============================================================================
# SERVICIOS DE NOTIFICACIONES
# =============================================================================

def get_all_notifications_service():
    """Obtiene lista de notificaciones con datos mínimos para preview"""
    try:
        rows = get_notifications()
        return [NotificationOut(**row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_notifications_by_user_service(id_user: int):
    """Obtiene notificaciones de un usuario con datos mínimos"""
    try:
        rows = get_notifications_by_user(id_user)
        return [NotificationOut(**row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_notifications_not_read_by_user_service(id_user: int):
    """Obtiene notificaciones no leídas de un usuario con datos mínimos"""
    try:
        rows = get_notifications_not_read_by_user(id_user)
        return [NotificationOut(**row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_notification_by_id_service(id_notification: int):
    """Obtiene una notificación específica con datos completos"""
    try:
        result = get_notification_by_id(id_notification)
        return NotificationOut(**result) if result else None
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def create_notification_service(notification: NotificationIn):
    """Crea una nueva notificación"""
    try:
        return create_notification(notification.id_user, notification.notification_type, notification.message)
    except mariadb.Error as e:
        raise HTTPException(status_code=400, detail=str(e))

def mark_notification_read_service(id_notification: int):
    """Marca una notificación como leída"""
    try:
        return mark_notification_read(id_notification)
    except mariadb.Error as e:
        raise HTTPException(status_code=400, detail=str(e)) 