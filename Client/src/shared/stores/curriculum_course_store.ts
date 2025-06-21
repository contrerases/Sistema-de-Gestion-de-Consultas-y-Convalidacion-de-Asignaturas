import { defineStore } from 'pinia'
import { getAllCurriculumCourses, deleteCurriculumCourse, insertCurriculumCourse,  } from '@/features/academic/curriculum/services/curriculm_course_api'
import type { CurriculumCourseBase } from '@/shared/types/curriculum_course_model'

interface State {
  curriculum_courses: CurriculumCourseBase[]
  isLoad: boolean
  error: Error | null
}

export const useCurriculumCourseStore = defineStore('curriculum_courses', {
  state: (): State => ({
    curriculum_courses: [],
    isLoad: false,
    error: null
  }),
  getters: {
    allCurriculumCourses: (state) => state.curriculum_courses,
    isLoading: (state) => state.isLoad,
    hasError: (state) => state.error !== null
  },
  actions: {
    async getCurriculumCoursesStore() {
     if (!this.isLoad){
       try {
         this.curriculum_courses = await getAllCurriculumCourses()
         this.isLoad = true
       } catch (error) {
         this.error = error as Error
       }
     }
    },
    async insertCurriculumCourseStore(curriculum_course: CurriculumCourseBase) {
      try {
        await insertCurriculumCourse(curriculum_course)
        await this.getCurriculumCoursesStore()
      } catch (error) {
        this.error = error as Error
      } 
    },
    async deleteCurriculumCourseStore(curriculum_course_id: number) {
      try {
        await deleteCurriculumCourse(curriculum_course_id)
        await this.getCurriculumCoursesStore()
      } catch (error) {
        this.error = error as Error
      }
    }
  }
})