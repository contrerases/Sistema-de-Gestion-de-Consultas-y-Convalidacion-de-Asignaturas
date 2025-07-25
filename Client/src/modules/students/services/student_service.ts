import { useApi } from '@/shared/composables/useApi'
import { API_ENDPOINTS } from '@/app/config/api'
import StudentCreateIn from '@/modules/students/types/student_in'

export function useStudentService() {
  const { loading, error, request } = useApi()

  async function getAll() {
    try {
      return await request({ url: API_ENDPOINTS.students.base, method: 'GET' })
    } catch (error: any) {
      throw error
    }
  }

  async function getById(id: number) {
    try {
      return await request({ url: API_ENDPOINTS.students.byId(id), method: 'GET' })
    } catch (error: any) {
      throw error
    }
  }

  async function getByRut(rut: string) {
    try {
      return await request({ url: API_ENDPOINTS.students.byRut(rut), method: 'GET' })
    } catch (error: any) {
      throw error
    }
  }

  async function getByName(name: string) {
    try {
      return await request({ url: API_ENDPOINTS.students.byName(name), method: 'GET' })
    } catch (error: any) {
      throw error
    }
  }

  async function getByRol(rol: string) {
    try {
      return await request({ url: API_ENDPOINTS.students.byRol(rol), method: 'GET' })
    } catch (error: any) {
      throw error
    }
  }

  async function create(data: StudentCreateIn) {
    try {
      return await request({ url: API_ENDPOINTS.students.base, method: 'POST', data })
    } catch (error: any) {
      throw error
    }
  }

  async function update(id: number, data: StudentCreateIn & { id_student: number }) {
    try {
      return await request({ url: API_ENDPOINTS.students.byId(id), method: 'PUT', data })
    } catch (error: any) {
      throw error
    }
  }

  async function remove(id: number) {
    try {
      return await request({ url: API_ENDPOINTS.students.byId(id), method: 'DELETE' })
    } catch (error: any) {
      throw error
    }
  }

  return { 
    loading, 
    error, 
    getAll, 
    getById, 
    getByRut, 
    getByName, 
    getByRol, 
    create, 
    update, 
    remove 
  }
} 