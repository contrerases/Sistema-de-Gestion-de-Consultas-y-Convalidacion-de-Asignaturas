import { defineStore } from 'pinia'
import type { WorkshopOut } from '@/modules/workshops/types/workshop_out'
import { getWorkshops } from '@/modules/workshops/services/workshop_service'

interface WorkshopStoreState {
  workshops: WorkshopOut[]
  loading: boolean
  error: string | null
}

export const useWorkshopStore = defineStore('workshop', {
  state: (): WorkshopStoreState => ({
    workshops: [],
    loading: false,
    error: null,
  }),
  actions: {
    async fetchWorkshops(): Promise<void> {
      this.loading = true
      this.error = null
      try {
        this.workshops = await getWorkshops() || []
      } catch (e: any) {
        this.error = e.message || 'Error al cargar talleres'
        throw e
      } finally {
        this.loading = false
      }
    },
    clear(): void {
      this.workshops = []
      this.error = null
    },
  },
}) 