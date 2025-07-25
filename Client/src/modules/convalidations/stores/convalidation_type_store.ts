import { defineStore } from 'pinia'
import type { ConvalidationTypeOut } from '@/modules/convalidations/types/convalidation_type_out'
import { getConvalidationTypes } from '@/modules/convalidations/services/convalidation_type_service'

interface ConvalidationTypeStoreState {
  types: ConvalidationTypeOut[]
  loading: boolean
  error: string | null
}

export const useConvalidationTypeStore = defineStore('convalidationType', {
  state: (): ConvalidationTypeStoreState => ({
    types: [],
    loading: false,
    error: null,
  }),
  actions: {
    async fetchTypes(): Promise<void> {
      this.loading = true
      this.error = null
      try {
        this.types = await getConvalidationTypes() || []
      } catch (e: any) {
        this.error = e.message || 'Error al cargar tipos de convalidación'
        throw e
      } finally {
        this.loading = false
      }
    },
    clear(): void {
      this.types = []
      this.error = null
    },
  },
}) 