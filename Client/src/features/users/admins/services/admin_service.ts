import { useApi } from '@/shared/composables/useApi'
import { API_ENDPOINTS } from '@/app/config/api'

import AdminIn from '@/modules/admins/types/admin_in'

export function useAdminService() {
  const { loading, error, request } = useApi()

  async function getAll() {
    return await request({ url: API_ENDPOINTS.admins.base, method: 'GET' })
  }

  async function getById(id: number) {
    return await request({ url: API_ENDPOINTS.admins.byId(id), method: 'GET' })
  }

  async function getByCampus(campus: string) {
    return await request({ url: API_ENDPOINTS.admins.byCampus(campus), method: 'GET' })
  }

  async function getByEmail(email: string) {
    return await request({ url: API_ENDPOINTS.admins.byEmail(email), method: 'GET' })
  }

  async function create(data: AdminIn) {
    return await request({ url: API_ENDPOINTS.admins.base, method: 'POST', data })
  }

  async function update(id: number, data: AdminIn & { id_admin: number }) {
    return await request({ url: API_ENDPOINTS.admins.byId(id), method: 'PUT', data })
  }

  async function remove(id: number) {
    return await request({ url: API_ENDPOINTS.admins.byId(id), method: 'DELETE' })
  }

  return { 
    loading, 
    error, 
    getAll, 
    getById, 
    getByCampus, 
    getByEmail, 
    create, 
    update, 
    remove 
  }
} 