import { createRouter, createWebHistory } from 'vue-router'

import AdminSetup from '../views/AdminSetup.vue'
import AdminReviewView from '../views/AdminReviewView.vue'
import StudentConvalidationView from '../views/StudentConvalidationView.vue'
import StudentView from '@/views/StudentView.vue'


const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/AdminSetup',
      name: 'AdminSetup',
      component: AdminSetup
    },
    {
      path: '/admin/convalidations',
      name: 'AdminView',
      component: AdminReviewView
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
