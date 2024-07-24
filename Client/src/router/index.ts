import { createRouter, createWebHistory } from 'vue-router'

import AdminView from '@/views/AdminView.vue'

import StudentView from '@/views/StudentView.vue'

import RequestModule from '@/modules/admin/requests/RequestModule.vue'
import HistoryModule from '@/modules/admin/history/HistoryModule.vue'
import CurriculumCoursesModule from '@/modules/admin/curriculum_courses/CurriculumCoursesModule.vue'
import StatsModule from '@/modules/admin/stats/StatsModule.vue'
import SubjectsModule from '@/modules/admin/subjects/SubjectsModule.vue'
import WorkshopsModule from '@/modules/admin/workshops/WorkshopsModule.vue'

import NewRequestModule from '@/modules/student/new_request/NewRequestModule.vue'


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
          path: 'historial',
          name: 'Historial',
          component: HistoryModule
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
      path: '/estudiante',
      name: 'Estudiante',
      component: StudentView,
      redirect: {name: 'S-Inicio'},

      children: [
    
        {
          path: 'inicio',
          name: 'S-Inicio',
          component: CurriculumCoursesModule
        }, 

        {
          path: 'convalidaciones',
          name: 'S-Convalidaciones',
          component: CurriculumCoursesModule
        }, 

        {
          path: 'talleres',
          name: 'S-Talleres',
          component: CurriculumCoursesModule
        },  

        {
          path: 'nueva_solicitud',
          name: 'S-NuevaSolicitud',
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
