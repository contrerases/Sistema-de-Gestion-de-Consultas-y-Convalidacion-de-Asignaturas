import { useApi } from '@/shared/composables/useApi'
import { API_ENDPOINTS } from '@/app/config/api'

import ConvalidationIn from '@/modules/convalidations/types/convalidation_in'
import ConvalidationReview from '@/modules/convalidations/types/convalidation_review'
import ConvalidationSearch from '@/modules/convalidations/types/convalidation_search'

export function useConvalidationService() {
  const { loading, error, request } = useApi()

  async function getAll() {
    try {
      return await request({ url: API_ENDPOINTS.convalidations.base, method: 'GET' })
    } catch (error: any) {
      throw error
    }
  }

  async function getById(id: number) {
    try {
      return await request({ url: API_ENDPOINTS.convalidations.byId(id), method: 'GET' })
    } catch (error: any) {
      throw error
    }
  }

  async function getPending() {
    try {
      return await request({ url: API_ENDPOINTS.convalidations.pending, method: 'GET' })
    } catch (error: any) {
      throw error
    }
  }

  async function getByStudent(studentId: number) {
    try {
      return await request({ url: API_ENDPOINTS.convalidations.byStudent(studentId), method: 'GET' })
    } catch (error: any) {
      throw error
    }
  }

  async function getByStudentRut(studentRut: string) {
    try {
      return await request({ url: API_ENDPOINTS.convalidations.byStudentRut(studentRut), method: 'GET' })
    } catch (error: any) {
      throw error
    }
  }

  async function getByStudentRol(studentRol: string) {
    try {
      return await request({ url: API_ENDPOINTS.convalidations.byStudentRol(studentRol), method: 'GET' })
    } catch (error: any) {
      throw error
    }
  }

  async function getByStudentName(studentName: string) {
    try {
      return await request({ url: API_ENDPOINTS.convalidations.byStudentName(studentName), method: 'GET' })
    } catch (error: any) {
      throw error
    }
  }

  async function getByReviewedBy(reviewedById: number) {
    try {
      return await request({ url: API_ENDPOINTS.convalidations.byReviewedBy(reviewedById), method: 'GET' })
    } catch (error: any) {
      throw error
    }
  }

  async function getByCurriculumCourse(curriculumCourseId: number) {
    try {
      return await request({ url: API_ENDPOINTS.convalidations.byCurriculumCourse(curriculumCourseId), method: 'GET' })
    } catch (error: any) {
      throw error
    }
  }

  async function getByWorkshop(workshopId: number) {
    try {
      return await request({ url: API_ENDPOINTS.convalidations.byWorkshop(workshopId), method: 'GET' })
    } catch (error: any) {
      throw error
    }
  }

  async function getByActivity(activityId: number) {
    try {
      return await request({ url: API_ENDPOINTS.convalidations.byActivity(activityId), method: 'GET' })
    } catch (error: any) {
      throw error
    }
  }

  async function getByType(typeId: number) {
    try {
      return await request({ url: API_ENDPOINTS.convalidations.byType(typeId), method: 'GET' })
    } catch (error: any) {
      throw error
    }
  }

  async function getByState(stateId: number) {
    try {
      return await request({ url: API_ENDPOINTS.convalidations.byState(stateId), method: 'GET' })
    } catch (error: any) {
      throw error
    }
  }

  async function filter(data: ConvalidationSearch) {
    try {
      return await request({ url: API_ENDPOINTS.convalidations.filter, method: 'POST', data })
    } catch (error: any) {
      throw error
    }
  }

  async function create(data: ConvalidationIn) {
    try {
      return await request({ url: API_ENDPOINTS.convalidations.base, method: 'POST', data })
    } catch (error: any) {
      throw error
    }
  }

  async function review(id: number, data: ConvalidationReview) {
    try {
      return await request({ url: API_ENDPOINTS.convalidations.review + id, method: 'PUT', data })
    } catch (error: any) {
      throw error
    }
  }

  async function dropWhileNoReviewedBy(id: number) {
    try {
      return await request({ url: API_ENDPOINTS.convalidations.dropWhileNoReviewedBy(id), method: 'DELETE' })
    } catch (error: any) {
      throw error
    }
  }

  return { 
    loading, 
    error, 
    getAll, 
    getById, 
    getPending, 
    getByStudent, 
    getByStudentRut, 
    getByStudentRol, 
    getByStudentName, 
    getByReviewedBy, 
    getByCurriculumCourse, 
    getByWorkshop, 
    getByActivity, 
    getByType, 
    getByState, 
    filter, 
    create, 
    review, 
    dropWhileNoReviewedBy 
  }
} 