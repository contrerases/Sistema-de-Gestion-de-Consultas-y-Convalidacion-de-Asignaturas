import { defineStore } from 'pinia'
import { getAllWorkshops, deleteWorkshop, insertWorkshop } from '@/shared/services/api/workshop_api'

import type { WorkshopResponse, WorkshopBase, WorkshopPost } from '@/features/workshops/management/types/workshop_model'

interface State {
  workshops: WorkshopResponse[]
  isLoad: boolean
  error: Error | null
}

export const useWorkshopsStore = defineStore('workshops', {
  state: (): State => ({
    workshops: [],
    isLoad: false,
    error: null
  }),
  getters: {
    allWorkshops: (state) => state.workshops,
    isLoading: (state) => state.isLoad,
    hasError: (state) => state.error !== null
  },
  actions: {
    async getWorkshopsStore() {
     if (this.isLoad) return
      try {
        this.workshops = await getAllWorkshops()
        this.isLoad = true
      } catch (error) {
        this.error = error as Error
      }
    },
    async insertWorkshopStore(workshop: WorkshopPost) {
      try {
        await insertWorkshop(workshop)
        await this.getWorkshopsStore()
      } catch (error) {
        this.error = error as Error
      } 
    },
    async deleteWorkshopStore(workshopId: number) {
      try {
        await deleteWorkshop(workshopId)
        await this.getWorkshopsStore()
      } catch (error) {
        this.error = error as Error
      }
    }
  }
})