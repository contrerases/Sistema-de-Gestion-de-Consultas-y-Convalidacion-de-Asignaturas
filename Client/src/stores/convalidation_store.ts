
import { defineStore } from 'pinia'
import { getAllConvalidations, insertConvalidation, updateConvalidation } from '@/services/convalidation_api'
import type { ConvalidationResponse, ConvalidationBase, ConvalidationUpdate } from '@/interfaces/convalidation_model'

interface State {
  convalidations: ConvalidationResponse[]
  isLoad: boolean
  error: Error | null
}

export const useConvalidationsStore = defineStore('convalidations', {
  state: (): State => ({
    convalidations: [],
    isLoad: false,
    error: null
  }),
  getters: {
    allConvalidations: (state) => state.convalidations,
    isLoading: (state) => state.isLoad,
    hasError: (state) => state.error !== null
  },
  actions: {
    async getAllConvalidationsStore() {
      if (!this.isLoad){
        try {
          this.convalidations = await getAllConvalidations()
          this.isLoad = true
        } catch (error) {
          this.error = error as Error
        }
      }
    },
    async insertConvalidationStore(convalidation: ConvalidationBase) {
      try {
        await insertConvalidation(convalidation)
        await this.getAllConvalidationsStore()
      } catch (error) {
        this.error = error as Error
      } 
    },
    async editConvalidation(convalidation: ConvalidationUpdate) {
      try {
        await updateConvalidation(convalidation)
        await this.getAllConvalidationsStore()
      } catch (error) {
        this.error = error as Error
      }
    }
  }
})

