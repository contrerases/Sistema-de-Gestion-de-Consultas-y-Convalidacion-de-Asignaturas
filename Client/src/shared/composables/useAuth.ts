import { computed } from 'vue'
import { useAuthStore } from '@/shared/stores/auth_store'

export function useAuth() {
  const store = useAuthStore()
  const isAuthenticated = computed(() => !!store.token)
  const user = computed(() => store.user)
  const login = store.login
  const logout = store.logout

  return { isAuthenticated, user, login, logout }
} 