import { useApi } from '@/shared/composables/useApi'
import { API_ENDPOINTS } from '@/app/config/api'
import SubjectIn from '@/modules/subjects/types/subject_in'
import SubjectOut from '@/modules/subjects/types/subject_out'

export function useSubjectService() {
  const { loading, error, request } = useApi()

  async function getAll() {
    try {
      return await request({ url: API_ENDPOINTS.subjects.base, method: 'GET' })
    } catch (error: any) {
      throw error
    }
  }

  async function getById(id: number) {
    try {
      return await request({ url: API_ENDPOINTS.subjects.byId(id), method: 'GET' })
    } catch (error: any) {
      throw error
    }
  }

  async function getByDepartment(departmentId: number) {
    try {
      return await request({ url: API_ENDPOINTS.subjects.byDepartment(departmentId), method: 'GET' })
    } catch (error: any) {
      throw error
    }
  }

  async function create(data: SubjectIn) {
    try {
      return await request({ url: API_ENDPOINTS.subjects.base, method: 'POST', data })
    } catch (error: any) {
      throw error
    }
  }

  async function update(id: number, data: SubjectIn) {
    try {
      return await request({ url: API_ENDPOINTS.subjects.byId(id), method: 'PUT', data })
    } catch (error: any) {
      throw error
    }
  }

  async function remove(id: number) {
    try {
      return await request({ url: API_ENDPOINTS.subjects.byId(id), method: 'DELETE' })
    } catch (error: any) {
      throw error
    }
  }

  return { 
    loading, 
    error, 
    getAll, 
    getById, 
    getByDepartment, 
    create, 
    update, 
    remove 
  }
} 