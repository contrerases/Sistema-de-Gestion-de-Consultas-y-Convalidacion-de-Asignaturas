import type { RouteRecordRaw } from 'vue-router'

import PublicLayout from '@/layouts/PublicLayout.vue'

import LoginView from '@/views/LoginView.vue'
import ChangePasswordView from '@/views/ChangePasswordView.vue'
import AboutView from '@/views/AboutView.vue'

export const publicRoutes: RouteRecordRaw = {
  path: '/',
  name: 'public',
  component: PublicLayout,
  meta: { requiresAuth: false },
  children: [
    { path: 'login', name: 'public-login', component: LoginView },
    { path: 'change-password', name: 'public-change-password', component: ChangePasswordView }  ,
    { path: 'about', name: 'public-about', component: AboutView },
  ]
} 

export default publicRoutes