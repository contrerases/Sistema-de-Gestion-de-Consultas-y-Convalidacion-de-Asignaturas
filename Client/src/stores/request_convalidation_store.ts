
import { defineStore } from 'pinia'
import {getConvalidationsByState} from '@/services/convalidation_api'

import type { ConvalidationResponse, ConvalidationBase, ConvalidationPost } from '@/interfaces/convalidation_model'
import { ConvalidationStates } from '@/enums/convalidation_states'

interface State {
  request_convalidations: ConvalidationResponse[]
  error: Error | null
}

export const useRequestConvalidationsStore = defineStore('request_convalidations', {
  state: (): State => ({
    request_convalidations: [],
    error: null
  }),
  getters: {
    allRequestConvalidations: (state) => state.request_convalidations,
  },
  actions: {
    async getAllRequestConvalidationsStore() {
        try {
          this.request_convalidations = await getConvalidationsByState(ConvalidationStates.ENVIADA)
        } catch (error) {
          this.error = error as Error
          throw error
        }
    },
  }
})

