import { createRouter, createWebHistory } from 'vue-router'

import AdminView from '@/views/AdminView.vue'
import StudentConvalidationView from '@/views/StudentConvalidationView.vue'
import StudentView from '@/views/StudentView.vue'


const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/Administrador',
      name: 'Administ',
      component: AdminView
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
