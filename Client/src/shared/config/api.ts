import axios, { AxiosInstance, AxiosRequestConfig, AxiosResponse } from 'axios'
import { useAuthStore } from '@/shared/stores/auth_store'
import { API_CONFIG, AUTH_CONFIG } from '@/app/config/env'
// Crear instancia de axios con configuración desde env.ts
const api: AxiosInstance = axios.create({
  baseURL: API_CONFIG.BASE_URL,
  timeout: API_CONFIG.TIMEOUT,
  headers: {
    'Content-Type': 'application/json',
  },
})

// Interceptor para agregar token de autenticación
api.interceptors.request.use(
  (config: AxiosRequestConfig) => {
    const authStore = useAuthStore()
    const token = authStore.token
    
    if (token) {
      config.headers = config.headers || {}
      config.headers.Authorization = `Bearer ${token}`
    }
    
    return config
  },
  (error) => {
    return Promise.reject(error)
  }
)

// Interceptor para manejar respuestas y errores
api.interceptors.response.use(
  (response: AxiosResponse) => {
    return response
  },
  (error) => {
    // Manejar errores de autenticación
    if (error.response?.status === 401) {
      const authStore = useAuthStore()
      authStore.logout()
      // Redirigir al login
      window.location.href = '/login'
    }
    
    // Manejar errores de servidor
    if (error.response?.status >= 500) {
      console.error('Error del servidor:', error.response.data)
    }
    
    return Promise.reject(error)
  }
)

export default api 