import { ref, computed, readonly } from 'vue'
import axios, { type AxiosResponse, type AxiosError } from 'axios'

interface ApiState {
  data: any
  loading: boolean
  error: string | null
}

interface ApiOptions {
  immediate?: boolean
  onSuccess?: (data: any) => void
  onError?: (error: string) => void
}

export function useApi() {
  const state = ref<ApiState>({
    data: null,
    loading: false,
    error: null
  })

  const isLoading = computed(() => state.value.loading)
  const hasError = computed(() => state.value.error !== null)
  const data = computed(() => state.value.data)

  const execute = async (
    requestFn: () => Promise<AxiosResponse>,
    options: ApiOptions = {}
  ): Promise<any> => {
    state.value.loading = true
    state.value.error = null

    try {
      const response = await requestFn()
      state.value.data = response.data
      options.onSuccess?.(response.data)
      return response.data
    } catch (error) {
      const axiosError = error as AxiosError
      const errorMessage = (axiosError.response?.data as any)?.message || axiosError.message || 'Error desconocido'
      state.value.error = errorMessage
      options.onError?.(errorMessage)
      return null
    } finally {
      state.value.loading = false
    }
  }

  const reset = () => {
    state.value = {
      data: null,
      loading: false,
      error: null
    }
  }

  return {
    state: readonly(state),
    isLoading,
    hasError,
    data,
    execute,
    reset
  }
}

// Configuración global de axios
axios.defaults.baseURL = import.meta.env.VITE_API_BASE_URL || 'http://localhost:3000/api'
axios.defaults.timeout = 10000

// Interceptor para agregar headers de autenticación
axios.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('auth_token')
    if (token) {
      config.headers.Authorization = `Bearer ${token}`
    }
    return config
  },
  (error) => {
    return Promise.reject(error)
  }
)

// Interceptor para manejar errores de respuesta
axios.interceptors.response.use(
  (response) => response,
  (error: AxiosError) => {
    if (error.response?.status === 401) {
      // Redirigir al login si no está autenticado
      localStorage.removeItem('auth_token')
      window.location.href = '/login'
    }
    return Promise.reject(error)
  }
) 