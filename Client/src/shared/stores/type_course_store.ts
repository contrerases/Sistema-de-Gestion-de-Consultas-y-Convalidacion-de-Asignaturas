import { defineStore } from 'pinia'
import { getAllTypesCourses, deleteTypeCourse } from '@/shared/services/api/type_convalidation_api'
import type { TypeConvalidationBase, TypeConvalidationResponse} from '@/shared/types/type_convalidation_model'

interface State {
  typesCourses: TypeConvalidationResponse[]
  isLoad: boolean
  error: Error | null
}

export const useTypesCoursesStore = defineStore('typesCourses', {
  state: (): State => ({
    typesCourses: [],
    isLoad: false,
    error: null
  }),
  getters: {
    allTypesCourses: (state) => state.typesCourses,
    isLoading: (state) => state.isLoad,
    hasError: (state) => state.error !== null
  },
  actions: {
    async getTypesCoursesStore() {
     if (this.isLoad) return
      try {
        this.typesCourses = await getAllTypesCourses()
        this.isLoad = true
      } catch (error) {
        this.error = error as Error
      }
    },
    
    async deleteTypeCourseStore(typeCourseId: number) {
      try {
        await deleteTypeCourse(typeCourseId)
        await this.getTypesCoursesStore()
      } catch (error) {
        this.error = error as Error
      }
    }
  }
})