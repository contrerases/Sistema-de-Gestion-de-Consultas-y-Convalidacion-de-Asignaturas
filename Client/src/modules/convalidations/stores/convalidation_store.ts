import { defineStore } from 'pinia'
import type { ConvalidationOut } from '@/modules/convalidations/types/convalidation_out'
import { getConvalidations } from '@/modules/convalidations/services/convalidation_service'

interface ConvalidationStoreState {
  convalidations: ConvalidationOut[]
  loading: boolean
  error: string | null
}

export const useConvalidationStore = defineStore('convalidation', {
  state: (): ConvalidationStoreState => ({
    convalidations: [],
    loading: false,
    error: null,
  }),
  actions: {
    async fetchConvalidations(){
      this.loading = true
      this.error = null
      try {
        this.convalidations = await getConvalidations() || []
      } catch (e: any) {
        this.error = e.message || 'Error al cargar convalidaciones'
        throw e
      } finally {
        this.loading = false
      }
    },
    clear(): void {
      this.convalidations = []
      this.error = null
    },
  },
}) 