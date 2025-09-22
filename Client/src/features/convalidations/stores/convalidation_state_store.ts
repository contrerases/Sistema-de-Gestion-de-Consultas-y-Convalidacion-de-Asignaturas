import { defineStore } from 'pinia'
import type { ConvalidationStateOut } from '@/modules/convalidations/types/convalidation_state_out'
import { getConvalidationStates } from '@/modules/convalidations/services/convalidation_state_service'

interface ConvalidationStateStoreState {
  states: ConvalidationStateOut[]
  loading: boolean
  error: string | null
}

export const useConvalidationStateStore = defineStore('convalidationState', {
  state: (): ConvalidationStateStoreState => ({
    states: [],
    loading: false,
    error: null,
  }),
  actions: {
    async fetchStates(): Promise<void> {
      this.loading = true
      this.error = null
      try {
        this.states = await getConvalidationStates() || []
      } catch (e: any) {
        this.error = e.message || 'Error al cargar estados de convalidación'
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