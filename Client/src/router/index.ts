import { createRouter, createWebHistory } from 'vue-router'

import HomeView from '../views/HomeView.vue'
import AdminReviewView from '../views/AdminReviewView.vue'
import StudentConvalidationView from '../views/StudentConvalidationView.vue'
import StudentView from '@/views/StudentView.vue'


const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: HomeView
    },
    {
      path: '/Admin',
      name: 'AdminView',
      component: AdminReviewView
    },
    {
      path: '/Student',
      name: 'StudentView',
      component: StudentView
    },

    {
      path: '/StudentConvalidation',
      name: 'StudentConvalidationView',
      component: StudentConvalidationView
    },

  ]
})

export default router
