from fastapi import HTTPException
import mariadb
from crud.notification import create_notification, get_notifications, mark_notification_read
from schemas.notification.notification_in import NotificationIn
from schemas.notification.notification_out import NotificationOut
from typing import Optional

def create_notification_service(notification: NotificationIn):
    try:
        return create_notification(notification.user_type, notification.notification_type, notification.message)
    except mariadb.Error as e:
        raise HTTPException(status_code=400, detail=str(e))

def get_notifications_service(id_user: Optional[int] = None, notification_type: Optional[str] = None, is_read: Optional[int] = None, is_sent: Optional[int] = None, user_type: Optional[str] = None, limit: Optional[int] = None):
    try:
        rows = get_notifications(id_user, notification_type, is_read, is_sent, user_type, limit)
        return [NotificationOut(**row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def mark_notification_read_service(id_notification: int, id_user: int):
    try:
        return mark_notification_read(id_notification, id_user)
    except mariadb.Error as e:
        raise HTTPException(status_code=400, detail=str(e))

def get_notifications_not_read_by_id_user_service(id_user: int, limit: Optional[int] = None):
    try:
        rows = get_notifications(id_user=id_user, is_read=0, limit=limit)
        return [NotificationOut(**row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e)) 