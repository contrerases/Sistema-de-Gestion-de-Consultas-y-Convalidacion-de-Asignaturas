
import { defineStore } from 'pinia'
import {getAllConvalidations, 
        getConvalidationsByState, 
        getConvalidationByID, 
        getConvalidationByStudentRol, 
        insertConvalidation, 
        updateConvalidation 
} from '@/shared/services/api/convalidation_api'

import type { ConvalidationResponse, ConvalidationInsert, ConvalidationUpdate, Convalidation } from '@/shared/types/convalidation_model'

interface State {
  convalidations: ConvalidationResponse[]
  studentConvalidations: ConvalidationResponse[]
  isLoad: boolean
  error: Error | null
}

export const useConvalidationsStore = defineStore('convalidations', {
  state: (): State => ({
    convalidations: [],
    studentConvalidations: [],
    isLoad: false,
    error: null
  }),
  getters: {
    allConvalidations: (state) => state.convalidations,
    getStudentConvalidations: (state) => state.studentConvalidations,
    isLoading: (state) => state.isLoad,
    hasError: (state) => state.error !== null
  },
  actions: {
    async getAllConvalidationsStore() {
 
        try {
          this.convalidations = await getAllConvalidations()
          this.isLoad = true
        } catch (error) {
          this.error = error as Error
        }
      
    },

    async getConvalidationsByStateStore(state: string) {
      try {
        this.convalidations = await getConvalidationsByState(state)
        this.isLoad = true
      } catch (error) {
        this.error = error as Error
      }
    },

    async getConvalidationByIDStore(id: number) {
      try {
        this.convalidations = [await getConvalidationByID(id)]
        this.isLoad = true
      } catch (error) {
        this.error = error as Error
      }
    },

    async getConvalidationByStudentRolStore(student_rol: string) {
      try {
        this.studentConvalidations = [await getConvalidationByStudentRol(student_rol)]
        this.isLoad = true
      } catch (error) {
        this.error = error as Error
      }
    },
    
    async insertConvalidationStore(convalidation: Convalidation) {
      try {
        await insertConvalidation(convalidation)
        await this.getAllConvalidationsStore()
      } catch (error) {
        this.error = error as Error
        throw error
      } 
    },
    async updateConvalidationStore(convalidation: ConvalidationUpdate) {
      try {
        await updateConvalidation(convalidation)
        await this.getAllConvalidationsStore()
      } catch (error) {
        this.error = error as Error
        throw error
      }
    }    
  }
})

