import { defineStore } from 'pinia'
import {getAllTypesCourses } from '@/shared/services/api/type_curriculum_course_api'
import type { TypeCurriculumCourseBase, TypeCurriculumCourseResponse } from '@/shared/types/type_curriculum_course_model'

interface State {
  typesCourses: TypeCurriculumCourseResponse[]
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
    }
  }
})