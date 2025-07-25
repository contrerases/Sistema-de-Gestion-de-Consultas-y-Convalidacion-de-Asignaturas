export default interface NotificationOut {
  id_notification: number
  id_auth_user: number
  notification_type: string
  message: string
  is_read: boolean
  created_at: string // datetime
  user_type: string
  limit?: number
} 