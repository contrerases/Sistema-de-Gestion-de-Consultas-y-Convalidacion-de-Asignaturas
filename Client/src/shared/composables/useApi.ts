import { ref } from 'vue'
import api from '@/shared/config/api'
import type { AxiosRequestConfig } from 'axios'

export function useApi<T = any>() {
  const loading = ref(false)
  const error = ref<string | null>(null)

  async function request(config: AxiosRequestConfig): Promise<T | null> {
    loading.value = true
    error.value = null
    
    try {
      const response = await api.request<T>(config)
      return response.data
    } catch (e: any) {
      error.value = e.response?.data?.detail || e.message || 'Error de red'
      return null
    } finally {
      loading.value = false
    }
  }

  // Métodos helper para requests comunes
  async function get<T = any>(url: string, config?: AxiosRequestConfig): Promise<T | null> {
    return request({ method: 'GET', url, ...config })
  }

  async function post<T = any>(url: string, data?: any, config?: AxiosRequestConfig): Promise<T | null> {
    return request({ method: 'POST', url, data, ...config })
  }

  async function put<T = any>(url: string, data?: any, config?: AxiosRequestConfig): Promise<T | null> {
    return request({ method: 'PUT', url, data, ...config })
  }

  async function del<T = any>(url: string, config?: AxiosRequestConfig): Promise<T | null> {
    return request({ method: 'DELETE', url, ...config })
  }

  return { 
    loading, 
    error, 
    request,
    get,
    post,
    put,
    del
  }
} 