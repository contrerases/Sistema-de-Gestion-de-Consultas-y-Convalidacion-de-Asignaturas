import { defineStore } from 'pinia'
import type { CurriculumCoursesTypeOut } from '@/modules/curriculum_courses_type/types/curriculum_courses_type_out'
import { getCurriculumCoursesTypes } from '@/modules/curriculum_courses_type/services/curriculum_courses_type_service'

interface CurriculumCoursesTypeStoreState {
  types: CurriculumCoursesTypeOut[]
  loading: boolean
  error: string | null
}

export const useCurriculumCoursesTypeStore = defineStore('curriculumCoursesType', {
  state: (): CurriculumCoursesTypeStoreState => ({
    types: [],
    loading: false,
    error: null,
  }),
  actions: {
    async fetchTypes(): Promise<void> {
      this.loading = true
      this.error = null
      try {
        this.types = await getCurriculumCoursesTypes() || []
      } catch (e: any) {
        this.error = e.message || 'Error al cargar tipos de cursos de currículum'
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