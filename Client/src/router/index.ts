import { createRouter, createWebHistory } from 'vue-router'

import AdminView from '@/views/AdminView.vue'

import StudentView from '@/views/StudentView.vue'

import RequestModule from '@/modules/admin/requests/RequestModule.vue'
import HistoryModule from '@/modules/admin/history/HistoryModule.vue'
import CurriculumCoursesModule from '@/modules/admin/curriculum_courses/CurriculumCoursesModule.vue'
import StatsModule from '@/modules/admin/stats/StatsModule.vue'
import SubjectsModule from '@/modules/admin/subjects/SubjectsModule.vue'
import WorkshopsModule from '@/modules/admin/workshops/WorkshopsModule.vue'


import WorkshopsModuleStudent from '@/modules/student/workshops/WorkshopsModuleStudent.vue'
import NewRequestModule from '@/modules/student/new_request/NewRequestModule.vue'
 

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/administrador',
      name: 'Administrador',
      component: AdminView,
      redirect: {name: 'a/estadisticas'},

      children: [

        {
          path: 'estadisticas',
          name: 'a/estadisticas',
          component: StatsModule
        },

        {
          path: 'solicitudes',
          name: 'a/solicitudes',
          component: RequestModule
        },

        {
          path: 'historial',
          name: 'a/historial',
          component: HistoryModule
        },

        {
          path: 'talleres',
          name: 'a/talleres',
          component: WorkshopsModule
        },
        
        {
          path: 'cursos',
          name: 'a/cursos',
          component: CurriculumCoursesModule
        },

        {
          path: 'asignaturas',
          name: 'a/asignaturas',
          component: SubjectsModule
        },

        {
          path: '/:pathMatch(.*)*',
          redirect: {name: 'Administrador'} 
        },
      ]
      
    },
    {
      path: '/estudiante',
      name: 'Estudiante',
      component: StudentView,
      redirect: {name: 's/inicio'},

      children: [
    
        {
          path: 'inicio',
          name: 's/inicio',
          component: CurriculumCoursesModule
        }, 

        {
          path: 'convalidaciones',
          name: 's/convalidaciones',
          component: CurriculumCoursesModule
        }, 

        {
          path: 'talleres',
          name: 's/talleres',
          component: WorkshopsModuleStudent
        },  

        {
          path: 'nueva_solicitud',
          name: 's/nueva_solicitud',
          component: NewRequestModule
        },

        {
          path: '/:pathMatch(.*)*',
          redirect: {name: 'Estudiante'} 
        },
        
      ]
    },


    

  ]
})

export default router
