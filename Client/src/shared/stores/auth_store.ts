import { defineStore } from 'pinia'
import type  AuthUserOut  from '@/modules/auth/types/auth_user_out'

interface AuthState {
  user: AuthUserOut | null
  token: string | null
}

export const useAuthStore = defineStore('auth', {
  state: (): AuthState => ({
    user: null,
    token: null,
  }),
  getters: {
    isAuthenticated: (state: AuthState) => !!state.token && !!state.user,
    userRole: (state: AuthState) => state.user?.user_type || null,
  },
  actions: {
    
    setUser(user: AuthUserOut, token: string) {
      this.user = user
      this.token = token
      localStorage.setItem('token', token)
      localStorage.setItem('user', JSON.stringify(user))
    },
    logout() {
      this.user = null
      this.token = null
      localStorage.removeItem('token')
      localStorage.removeItem('user')
    },
    loadFromStorage() {
      const token = localStorage.getItem('token')
      const user = localStorage.getItem('user')
      if (token && user) {
        this.token = token
        this.user = JSON.parse(user)
      }
    },
  },
}) 