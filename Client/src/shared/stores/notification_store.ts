import { defineStore } from 'pinia'

interface Notification {
  id: number
  message: string
  type: 'success' | 'error' | 'info' | 'warning'
}

export const useNotificationStore = defineStore('notification', {
  state: () => ({
    notifications: [] as Notification[],
    nextId: 1,
  }),
  actions: {
    notify(message: string, type: Notification['type'] = 'info') {
      this.notifications.push({ id: this.nextId++, message, type })
    },
    remove(id: number) {
      this.notifications = this.notifications.filter(n => n.id !== id)
    },
    clear() {
      this.notifications = []
    },
  },
}) 