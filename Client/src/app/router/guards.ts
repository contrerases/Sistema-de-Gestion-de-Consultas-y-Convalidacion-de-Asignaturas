import { useAuthStore } from '@/shared/stores/auth_store'
import type { NavigationGuardNext, RouteLocationNormalized } from 'vue-router'

export default function authGuard(to: RouteLocationNormalized, from: RouteLocationNormalized, next: NavigationGuardNext) {
  const auth = useAuthStore()
  if (to.meta.requiresAuth && !auth.isAuthenticated) {
    return next({ name: 'public-login' })
  }
  if (to.meta.role && auth.userRole !== to.meta.role) {
    return next({ path: '/public-login' }) 
  }
  return next()
} 