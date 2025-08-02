// API Base Types

// Tipos de respuesta base
export interface ApiResponse<T = any> {
  data: T
  message?: string
  success: boolean
}

export interface ApiError {
  detail: string
  status_code: number
  timestamp: string
}

// Tipos de paginación
export interface PaginationParams {
  page?: number
  limit?: number
  sort_by?: string
  sort_order?: 'asc' | 'desc'
}

export interface PaginatedResponse<T> {
  data: T[]
  pagination: {
    page: number
    limit: number
    total: number
    total_pages: number
  }
}

// Tipos de filtros
export interface FilterParams {
  search?: string
  status?: string
  date_from?: string
  date_to?: string
  [key: string]: any
}

// Tipos de request
export interface CreateRequest<T = any> {
  data: T
}

export interface UpdateRequest<T = any> {
  id: number | string
  data: Partial<T>
}

export interface DeleteRequest {
  id: number | string
}

// Tipos de respuesta común
export interface SuccessResponse {
  success: boolean
  message: string
}

export interface ErrorResponse {
  success: false
  error: string
  details?: any
} 