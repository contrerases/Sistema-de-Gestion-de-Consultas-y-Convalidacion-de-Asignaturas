import { defineStore } from 'pinia'
import type { StudentOut } from '@/modules/students/types/student_out'
import { getStudents } from '@/modules/students/services/student_service'

interface StudentStoreState {
  students: StudentOut[]
  loading: boolean
  error: string | null
}

export const useStudentStore = defineStore('student', {
  state: (): StudentStoreState => ({
    students: [],
    loading: false,
    error: null,
  }),
  actions: {
    async fetchStudents(): Promise<void> {
      this.loading = true
      this.error = null
      try {
        this.students = await getStudents() || []
      } catch (e: any) {
        this.error = e.message || 'Error al cargar estudiantes'
        throw e
      } finally {
        this.loading = false
      }
    },
    clear(): void {
      this.students = []
      this.error = null
    },
  },
}) 