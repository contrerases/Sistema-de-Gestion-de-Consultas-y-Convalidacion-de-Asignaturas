import { useApi } from '@/shared/composables/useApi'
import { API_ENDPOINTS } from '@/app/config/api'
import WorkshopInscriptionIn from '@/modules/workshops/types/workshop_inscription_in'
import WorkshopInscriptionOut from '@/modules/workshops/types/workshop_inscription_out'


export function useWorkshopInscriptionService() {
  const { loading, error, request } = useApi()

  async function getAll() {
    return await request({ url: API_ENDPOINTS.workshopInscriptions.base, method: 'GET' })
  }

  async function getById(id: number) {
    return await request({ url: API_ENDPOINTS.workshopInscriptions.byId(id), method: 'GET' })
  }

  async function getByWorkshop(workshopId: number) {
    return await request({ url: API_ENDPOINTS.workshopInscriptions.byWorkshop(workshopId), method: 'GET' })
  }

  async function getByStudent(studentId: number) {
    return await request({ url: API_ENDPOINTS.workshopInscriptions.byStudent(studentId), method: 'GET' })
  }

  async function getByStudentRut(studentRut: string) {
    return await request({ url: API_ENDPOINTS.workshopInscriptions.byStudentRut(studentRut), method: 'GET' })
  }

  async function getByStudentName(studentName: string) {
    return await request({ url: API_ENDPOINTS.workshopInscriptions.byStudentName(studentName), method: 'GET' })
  }

  async function getByStudentRol(studentRol: string) {
    return await request({ url: API_ENDPOINTS.workshopInscriptions.byStudentRol(studentRol), method: 'GET' })
  }

  async function getByCurriculumCourse(curriculumCourseId: number) {
    return await request({ url: API_ENDPOINTS.workshopInscriptions.byCurriculumCourse(curriculumCourseId), method: 'GET' })
  }

  async function create(data: WorkshopInscriptionIn) {
    return await request({ url: API_ENDPOINTS.workshopInscriptions.base, method: 'POST', data })
  }

  async function update(id: number, data: WorkshopInscriptionIn) {
    return await request({ url: API_ENDPOINTS.workshopInscriptions.byId(id), method: 'PUT', data })
  }

  async function cancelInscription(id: number) {
    return await request({ url: API_ENDPOINTS.workshopInscriptions.cancelInscription(id), method: 'DELETE' })
  }

  return { 
    loading, 
    error, 
    getAll, 
    getById, 
    getByWorkshop, 
    getByStudent, 
    getByStudentRut, 
    getByStudentName, 
    getByStudentRol, 
    getByCurriculumCourse, 
    create, 
    update, 
    cancelInscription 
  }
} 