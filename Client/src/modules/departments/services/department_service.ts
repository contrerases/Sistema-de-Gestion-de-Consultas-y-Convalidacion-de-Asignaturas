import { useApi } from '@/shared/composables/useApi'
import { API_ENDPOINTS } from '@/app/config/api'
import DepartmentIn from '@/modules/departments/types/department_in'
import DepartmentOut from '@/modules/departments/types/department_out'

export function useDepartmentService() {
  const { loading, error, request } = useApi()

  async function getAll() {
    return await request({ url: API_ENDPOINTS.departments.base, method: 'GET' })
  }

  async function getById(id: number) {
    return await request({ url: API_ENDPOINTS.departments.byId(id), method: 'GET' })
  }

  async function create(data: DepartmentIn) {
    return await request({ url: API_ENDPOINTS.departments.base, method: 'POST', data })
  }

  async function update(id: number, data: DepartmentIn) {
    return await request({ url: API_ENDPOINTS.departments.byId(id), method: 'PUT', data })
  }

  async function remove(id: number) {
    return await request({ url: API_ENDPOINTS.departments.byId(id), method: 'DELETE' })
  }

  return { loading, error, getAll, getById, create, update, remove }
} 