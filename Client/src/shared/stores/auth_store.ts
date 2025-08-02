import { defineStore } from 'pinia'
import type AuthUserOut from '@/modules/auth/types/auth_user_out'
import { AUTH_CONFIG } from '@/app/config/env'

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
    async login(email: string, password: string) {
      // Aquí implementarías la lógica de login real
      // Por ahora es un placeholder
      console.log('Login attempt:', email)
      
      // Simular login exitoso
      const mockUser = {
        id_auth_user: 1,
        email: email,
        id_user: 1,
        first_names: 'Usuario',
        last_names: 'Ejemplo',
        common_name: 'Usuario Ejemplo',
        full_name: 'Usuario Ejemplo',
        campus: 'Campus Principal',
        created_at: new Date().toISOString(),
        updated_at: new Date().toISOString(),
        user_type: 'admin'
      } as AuthUserOut
      
      const mockToken = 'mock-jwt-token'
      
      this.setUser(mockUser, mockToken)
      return { user: mockUser, token: mockToken }
    },
    
    setUser(user: AuthUserOut, token: string) {
      this.user = user
      this.token = token
      localStorage.setItem(AUTH_CONFIG.TOKEN_KEY, token)
      localStorage.setItem(AUTH_CONFIG.USER_KEY, JSON.stringify(user))
    },
    
    logout() {
      this.user = null
      this.token = null
      localStorage.removeItem(AUTH_CONFIG.TOKEN_KEY)
      localStorage.removeItem(AUTH_CONFIG.USER_KEY)
      localStorage.removeItem(AUTH_CONFIG.REFRESH_TOKEN_KEY)
    },
    
    loadFromStorage() {
      const token = localStorage.getItem(AUTH_CONFIG.TOKEN_KEY)
      const user = localStorage.getItem(AUTH_CONFIG.USER_KEY)
      if (token && user) {
        this.token = token
        this.user = JSON.parse(user)
      }
    },
  },
}) 