import { ref } from 'vue'
import axios, { AxiosRequestConfig } from 'axios'

export function useApi<T = any>() {
  const loading = ref(false)
  const error = ref<string | null>(null)

  async function request(config: AxiosRequestConfig): Promise<T | null> {
    loading.value = true
    error.value = null
    try {
      const response = await axios.request<T>(config)
      return response.data
    } catch (e: any) {
      error.value = e.response?.data?.detail || e.message || 'Error de red'
      return null
    } finally {
      loading.value = false
    }
  }

  return { loading, error, request }
} 