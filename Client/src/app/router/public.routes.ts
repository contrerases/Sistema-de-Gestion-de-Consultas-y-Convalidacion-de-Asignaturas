import type { RouteRecordRaw } from 'vue-router'

import PublicLayout from '@/layouts/PublicLayout.vue'
import PublicHomeView from '@/views/PublicHomeView.vue'
import LoginView from '@/views/LoginView.vue'
import ChangePasswordView from '@/views/ChangePasswordView.vue'
import AboutView from '@/views/AboutView.vue'

export const publicRoutes: RouteRecordRaw = {
  path: '/',
  name: 'public',
  component: PublicLayout,
  children: [
    { path: '', name: 'public-home', component: PublicHomeView, redirect: { name: 'login' } },
    { path: 'login', name: 'login', component: LoginView, name: 'login' },
    { path: 'change-password', name: 'change-password', component: ChangePasswordView, name: 'change-password' }  ,
    { path: 'about', name: 'public-about', component: AboutView, name: 'public-about' },
  ]
} 