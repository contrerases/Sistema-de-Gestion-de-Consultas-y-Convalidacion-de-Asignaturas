from fastapi import HTTPException
import mariadb
from crud.notification import create_notification, get_notifications, mark_notification_read
from schemas.notification.notification_in import NotificationIn
from schemas.notification.notification_out import NotificationOut
from schemas.notification.notification_filter_in import NotificationFilterIn

def create_notification_service(notification: NotificationIn):
    try:
        return create_notification(notification.dict())
    except mariadb.Error as e:
        raise HTTPException(status_code=400, detail=str(e))

def get_notifications_service(filters: NotificationFilterIn):
    try:
        rows = get_notifications(
            filters.id_user,
            filters.notification_type,
            filters.is_read,
            filters.is_sent,
            filters.user_type,
            filters.limit
        )
        return [NotificationOut(**row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def mark_notification_read_service(id_notification: int, id_user: int):
    try:
        return mark_notification_read(id_notification, id_user)
    except mariadb.Error as e:
        raise HTTPException(status_code=400, detail=str(e)) 