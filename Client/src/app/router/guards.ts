import { useAuthStore } from '@/shared/stores/auth_store'
import type { NavigationGuardNext, RouteLocationNormalized } from 'vue-router'

export function authGuard(to: RouteLocationNormalized, from: RouteLocationNormalized, next: NavigationGuardNext) {
  const auth = useAuthStore()
  if (to.meta.requiresAuth && !auth.isAuthenticated) {
    return next({ name: 'login' })
  }
  if (to.meta.role && auth.userRole !== to.meta.role) {
    return next({ path: '/' }) // Redirige a la raíz si no tiene el rol
  }
  return next()
} 