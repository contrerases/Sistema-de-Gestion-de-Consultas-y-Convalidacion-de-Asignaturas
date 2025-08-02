import { defineStore } from 'pinia'
import type { SubjectOut } from '@/modules/subjects/types/subject_out'
import { getSubjects } from '@/modules/subjects/services/subject_service'

interface SubjectStoreState {
  subjects: SubjectOut[]
  loading: boolean
  error: string | null
}

export const useSubjectStore = defineStore('subject', {
  state: (): SubjectStoreState => ({
    subjects: [],
    loading: false,
    error: null,
  }),
  actions: {
    async fetchSubjects(): Promise<void> {
      this.loading = true
      this.error = null
      try {
        this.subjects = await getSubjects() || []
      } catch (e: any) {
        this.error = e.message || 'Error al cargar materias'
        throw e
      } finally {
        this.loading = false
      }
    },
    clear(): void {
      this.subjects = []
      this.error = null
    },
  },
}) 