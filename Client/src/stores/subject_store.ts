import { defineStore } from 'pinia'
import {getAllSubject, deleteSubject, insertSubject  } from '@/services/subject_api'

import type { SubjectResponse, SubjectBase, SubjectPost } from '@/interfaces/subject_model'

interface State {
  subjects: SubjectResponse[]
  isLoad: boolean
  error: Error | null
}

export const useSubjectsStore = defineStore('subjects', {
  state: (): State => ({
    subjects: [],
    isLoad: false,
    error: null
  }),
  getters: {
    allSubjects: (state) => state.subjects,
    isLoading: (state) => state.isLoad,
    hasError: (state) => state.error !== null
  },
  actions: {
    async getSubjectsStore() {
      try {
        this.subjects = await getAllSubject()
        this.isLoad = true
      } catch (error) {
        this.error = error as Error
      }
    },
    async insertSubjectStore(subject: SubjectPost) {
      try {
        await insertSubject(subject)
      } catch (error) {
        this.error = error as Error
      } 
    },
    async deleteSubjectStore(subjectId: number) {
      try {
        await deleteSubject(subjectId)
      } catch (error) {
        console.error('Error en deleteSubjectStore:', this.error);
        this.error = error as Error
        throw error;
      }
    }
  }
})