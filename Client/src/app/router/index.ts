import { createRouter, createWebHistory } from 'vue-router'

import adminRoutes from '@/app/router/admin.routes'
import  studentRoutes  from '@/app/router/student.routes'
import publicRoutes  from '@/app/router/public.routes'
import  authGuard  from '@/app/router/guards'

const routes = [
  adminRoutes,
  studentRoutes,
  publicRoutes
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

// router.beforeEach(authGuard)

export default router 