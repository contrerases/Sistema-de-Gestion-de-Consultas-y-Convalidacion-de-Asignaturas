import { defineStore } from 'pinia'
import type { WorkshopStateOut } from '@/modules/workshops/types/workshop_state_out'
import { getWorkshopStates } from '@/modules/workshops/services/workshop_state_service'

interface WorkshopStateStoreState {
  states: WorkshopStateOut[]
  loading: boolean
  error: string | null
}

export const useWorkshopStateStore = defineStore('workshopState', {
  state: (): WorkshopStateStoreState => ({
    states: [],
    loading: false,
    error: null,
  }),
  actions: {
    async fetchStates(): Promise<void> {
      this.loading = true
      this.error = null
      try {
        this.states = await getWorkshopStates() || []
      } catch (e: any) {
        this.error = e.message || 'Error al cargar estados de taller'
        throw e
      } finally {
        this.loading = false
      }
    },
    clear(): void {
      this.states = []
      this.error = null
    },
  },
}) 