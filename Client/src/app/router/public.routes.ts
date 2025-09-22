import type { RouteRecordRaw } from 'vue-router';

import PublicLayout from '@/layouts/PublicLayout.vue';

import LoginView from '@/views/public/LoginView.vue';
import ChangePasswordView from '@/views/public/ChangePasswordView.vue';
import AboutView from '@/views/public/AboutView.vue';
import HomeView from '@/views/public/HomeView.vue';

export const publicRoutes: RouteRecordRaw = {
  path: '/',
  name: 'public',
  component: PublicLayout,
  meta: { requiresAuth: false },
  children: [
    { path: '', name: 'public-home', component: HomeView },
    { path: 'login', name: 'public-login', component: LoginView },
    {
      path: 'change-password',
      name: 'public-change-password',
      component: ChangePasswordView,
    },
    { path: 'about', name: 'public-about', component: AboutView },
  ],
};
export default publicRoutes;
