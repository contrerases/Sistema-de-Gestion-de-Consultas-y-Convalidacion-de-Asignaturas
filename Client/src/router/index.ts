import { createRouter, createWebHistory } from 'vue-router'

import AdminView from '@/views/AdminView.vue'
import StudentConvalidationView from '@/views/StudentConvalidationView.vue'
import StudentView from '@/views/StudentView.vue'

import RequestModule from '@/modules/admin/requests/RequestModule.vue'
import ConvalidationsModule from '@/modules/admin/convalidations/ConvalidationsModule.vue'
import CurriculumCoursesModule from '@/modules/admin/curriculum_courses/CurriculumCoursesModule.vue'
import StatsModule from '@/modules/admin/stats/StatsModule.vue'
import SubjectsModule from '@/modules/admin/subjects/SubjectsModule.vue'
import WorkshopsModule from '@/modules/admin/workshops/WorkshopsModule.vue'


const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/administrador',
      name: 'Administrador',
      component: AdminView,
      redirect: {name: 'Estadisticas'},

      children: [

        {
          path: 'estadisticas',
          name: 'Estadisticas',
          component: StatsModule
        },

        {
          path: 'solicitudes',
          name: 'Solicitudes',
          component: RequestModule
        },

        {
          path: 'convalidaciones',
          name: 'Convalidaciones',
          component: ConvalidationsModule
        },

        {
          path: 'talleres',
          name: 'Talleres',
          component: WorkshopsModule
        },
        
        {
          path: 'cursos',
          name: 'Cursos',
          component: CurriculumCoursesModule
        },

        {
          path: 'asignaturas',
          name: 'Asignaturas',
          component: SubjectsModule
        },

        {
          path: '/:pathMatch(.*)*',
          redirect: {name: 'Administrador'} 
        },
      ]
      
    },
    {
      path: '/Student',
      name: 'StudentView',
      component: StudentView
    },

    {
      path: '/StudentConvalidations',
      name: 'StudentConvalidationView',
      component: StudentConvalidationView
    },

    

  ]
})

export default router
