import { createRouter, createWebHistory } from 'vue-router'
import HomeLayout from '@/layouts/HomeLayout.vue'
import { adminRoutes } from '@/router/admin.routes'
import { studentRoutes } from '@/router/student.routes'
import { useAuthStore } from '@/shared/stores/auth_store'

const routes = [
  {
    path: '/',
    name: 'home',
    component: HomeLayout,
  },
  ...adminRoutes,
  ...studentRoutes,   
]

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes,
})

// Guard de Navegación Global
router.beforeEach((to, from, next) => {
  const authStore = useAuthStore();
  if (to.meta.requiresAdmin && !authStore.isAdmin) {
    return next({ name: 'home' });
  }
  if (to.meta.requiresStudent && authStore.isAdmin) {
    return next({ name: 'home' });
  }
  if (to.name === 'home' && authStore.isAuthenticated) {
    return next({ name: authStore.isAdmin ? 'admin' : 'student' });
  }
  return next(); 
});

export default router;
