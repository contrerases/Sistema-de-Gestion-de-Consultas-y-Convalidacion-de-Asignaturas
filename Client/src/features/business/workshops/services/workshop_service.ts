import { useApi } from '@/shared/composables/useApi'
import { API_ENDPOINTS } from '@/app/config/api'
import WorkshopIn from '@/modules/workshops/types/workshop_in'
import WorkshopOut from '@/modules/workshops/types/workshop_out'
import WorkshopSearch from '@/modules/workshops/types/workshop_search'


export function useWorkshopService() {
  const { loading, error, request } = useApi()

  async function getAll() {
    try {
      return await request({ url: API_ENDPOINTS.workshops.base, method: 'GET' })
    } catch (error: any) {
      throw error
    }
  }

  async function getById(id: number) {
    try {
      return await request({ url: API_ENDPOINTS.workshops.byId(id), method: 'GET' })
    } catch (error: any) {
      throw error
    }
  }

  async function getByState(stateId: number) {
    try {
      return await request({ url: API_ENDPOINTS.workshops.byState(stateId), method: 'GET' })
    } catch (error: any) {
      throw error
    }
  }

  async function getByProfessor(professor: string) { 
    try {
      return await request({ url: API_ENDPOINTS.workshops.byProfessor(professor), method: 'GET' })
    } catch (error: any) {
      throw error
    }
  }

  async function search(data: WorkshopSearch) {
    try {
      return await request({ url: API_ENDPOINTS.workshops.search, method: 'POST', data })
    } catch (error: any) {
      throw error
    }
  }

  async function changeState(id: number) {
    try {
      return await request({ url: API_ENDPOINTS.workshops.changeState(id), method: 'POST' })
    } catch (error: any) {
      throw error
    }
  }

  async function create(data: WorkshopIn) {
    try {
      return await request({ url: API_ENDPOINTS.workshops.base, method: 'POST', data })
    } catch (error: any) {
      throw error
    }
  }

  async function update(id: number, data: WorkshopIn) {
    try {
      return await request({ url: API_ENDPOINTS.workshops.byId(id), method: 'PUT', data })
    } catch (error: any) {
      throw error
    }
  }

  async function remove(id: number) {
    try {
      return await request({ url: API_ENDPOINTS.workshops.byId(id), method: 'DELETE' })
    } catch (error: any) {
      throw error
    }
  }

  return { 
    loading, 
    error, 
    getAll, 
    getById, 
    getByState, 
    getByProfessor, 
    search, 
    changeState, 
    create, 
    update, 
    remove 
  }
} 