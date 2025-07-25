import { useApi } from '@/shared/composables/useApi'
import { API_ENDPOINTS } from '@/app/config/api'
import CurriculumCourseIn from '@/modules/curriculum-courses/types/curriculum_course_in'
import CurriculumCourseOut from '@/modules/curriculum-courses/types/curriculum_course_out'

export function useCurriculumCourseService() {
  const { loading, error, request } = useApi()

  async function getAll() {
    return await request({ url: API_ENDPOINTS.curriculumCourses.base, method: 'GET' })
  }

  async function getById(id: number) {
    return await request({ url: API_ENDPOINTS.curriculumCourses.byId(id), method: 'GET' })
  }

  async function getByType(typeId: number) {
    return await request({ url: API_ENDPOINTS.curriculumCourses.byType(typeId), method: 'GET' })
  }

  async function getNotConvalidatedByStudent(studentId: number) {
    return await request({ url: API_ENDPOINTS.curriculumCourses.notConvalidatedByStudent(studentId), method: 'GET' })
  }

  async function create(data: CurriculumCourseIn) {
    return await request({ url: API_ENDPOINTS.curriculumCourses.base, method: 'POST', data })
  }

  async function update(id: number, data: CurriculumCourseUpdateIn) {
    return await request({ url: API_ENDPOINTS.curriculumCourses.byId(id), method: 'PUT', data })
  }

  async function remove(id: number) {
    return await request({ url: API_ENDPOINTS.curriculumCourses.byId(id), method: 'DELETE' })
  }

  return { 
    loading, 
    error, 
    getAll, 
    getById, 
    getByType, 
    getNotConvalidatedByStudent, 
    create, 
    update, 
    remove 
  }
} 