import { createRouter, createWebHistory } from 'vue-router'

import AdminView from '@/views/AdminView.vue'

import StudentView from '@/views/StudentView.vue'

import HomeView from '@/views/HomeView.vue'



import RequestModule from '@/features/convalidations/requests/components/RequestModule.vue'
import HistoryModule from '@/features/convalidations/history/components/HistoryModule.vue'
import CurriculumCoursesModule from '@/features/academic/curriculum/components/CurriculumCoursesModule.vue'
import StatsModule from '@/features/dashboard/components/StatsModule.vue' 
import SubjectsModule from '@/features/academic/subjects/components/SubjectsModule.vue'
import WorkshopsModule from '@/features/workshops/WorkshopsModule.vue'
import DepartmentModule from '@/features/academic/departments/components/DepartmentModule.vue'
import WorkshopsCurrentList from '@/features/workshops/WorkshopsCurrentList.vue'
import WorkshopsPastList from '@/features/workshops/WorkshopsPastList.vue'


import WorkshopsModuleStudent from '@/features/workshops/WorkshopsModuleStudent.vue'
import NewRequestModule from '@/features/convalidations/requests/components/NewRequestModule.vue'
import HomeModule from '@/features/home/HomeModule.vue'
import HistoryModuleStudent from '@/features/convalidations/history/components/HistoryModuleStudent.vue'


import { useAuthStore } from '@/shared/stores/auth_store';



const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'Inicio',
      component: HomeView,
    },
    {
      path: '/administrador',
      name: 'Administrador',
      component: AdminView,
      meta: { requiresAdmin: true },
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
          component: WorkshopsModule,

          children: [
            
            {
              path: "actuales",
              name: "a/actuales",
              component: WorkshopsCurrentList,
            },
            {
              path: "pasados",
              name: "a/pasados",
              component: WorkshopsPastList,
            },
          ],

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
          path: 'departamentos',
          name: 'a/departamentos',
          component: DepartmentModule
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
      meta: { requiresStudent: true },
      redirect: {name: 's/inicio'},

      children: [
    
        {
          path: 'inicio',
          name: 's/inicio',
          component: HomeModule
        }, 

        {
          path: 'convalidaciones',
          name: 's/convalidaciones',
          component: HistoryModuleStudent
        }, 

        {
          path: 'talleres',
          name: 's/talleres',
          component: WorkshopsModuleStudent,

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


// Guard de Navegación Global
router.beforeEach((to, from, next) => {
  const authStore = useAuthStore(); // Accede al auth store

  // Verifica si la ruta requiere que el usuario sea administrador
  if (to.meta.requiresAdmin && !authStore.isAdmin) {
    return next({ name: 'Inicio' }); // Redirigir al Home (Inicio)
  }

  // Verifica si la ruta requiere que el usuario sea estudiante
  if (to.meta.requiresStudent && authStore.isAdmin) {

    return next({ name: 'Inicio' }); // Redirigir al Home (Inicio)
  }

  if (to.name === 'Inicio' && authStore.isAuthenticated) {
    // Redirige según el rol del usuario
    return next({ name: authStore.isAdmin ? 'Administrador' : 'Estudiante' });
  }

  return next(); 
  
});

export default router
