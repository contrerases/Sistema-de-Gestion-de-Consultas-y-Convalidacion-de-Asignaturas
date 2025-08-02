import { useApi } from '@/shared/composables/useApi'
import { API_ENDPOINTS } from '@/app/config/api'
import NotificationIn from '@/modules/notifications/types/notification_in'
import NotificationOut from '@/modules/notifications/types/notification_out'


export function useNotificationService() {
  const { loading, error, request } = useApi()

  async function getByUser(userId: number) {
    return await request({ url: API_ENDPOINTS.notifications.byUser(userId), method: 'GET' })
  }

  async function getNotReadByUser(userId: number) {
    return await request({ url: API_ENDPOINTS.notifications.notReadByUser(userId), method: 'GET' })
  }

  async function markAsRead(notificationId: number) {
    return await request({ url: API_ENDPOINTS.notifications.markAsRead(notificationId), method: 'POST' })
  }

  return { 
    loading, 
    error, 
    getByUser, 
    getNotReadByUser, 
    markAsRead 
  }
} 