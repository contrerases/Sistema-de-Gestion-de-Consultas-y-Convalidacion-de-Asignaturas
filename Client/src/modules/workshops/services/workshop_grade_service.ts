import { useApi } from '@/shared/composables/useApi'
import { API_ENDPOINTS } from '@/app/config/api'
import WorkshopGradeIn from '@/modules/workshops/types/workshop_grade_in'
import WorkshopGradeOut from '@/modules/workshops/types/workshop_grade_out'

export function useWorkshopGradeService() {
  const { loading, error, request } = useApi()

  async function getAll() {
    return await request({ url: API_ENDPOINTS.workshopGrades.base, method: 'GET' })
  }

  async function getById(id: number) {
    return await request({ url: API_ENDPOINTS.workshopGrades.byId(id), method: 'GET' })
  }

  async function getByWorkshop(workshopId: number) {
    return await request({ url: API_ENDPOINTS.workshopGrades.byWorkshop(workshopId), method: 'GET' })
  }

  async function getByStudent(studentId: number) {
    return await request({ url: API_ENDPOINTS.workshopGrades.byStudent(studentId), method: 'GET' })
  }

  async function create(data: WorkshopGradeIn) {
    return await request({ url: API_ENDPOINTS.workshopGrades.base, method: 'POST', data })
  }

  async function update(id: number, data: WorkshopGradeIn) {
    return await request({ url: API_ENDPOINTS.workshopGrades.byId(id), method: 'PUT', data })
  }

  async function remove(id: number) {
    return await request({ url: API_ENDPOINTS.workshopGrades.byId(id), method: 'DELETE' })
  }

  return { 
    loading, 
    error, 
    getAll, 
    getById, 
    getByWorkshop, 
    getByStudent, 
    create, 
    update, 
    remove 
  }
} 