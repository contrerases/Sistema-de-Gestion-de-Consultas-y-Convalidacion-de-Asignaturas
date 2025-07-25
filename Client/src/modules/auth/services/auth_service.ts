import { useApi } from '@/shared/composables/useApi'
import { API_ENDPOINTS } from '@/app/config/api'
import LoginIn from '@/modules/auth/types/login_in'
import ChangePasswordIn from '@/modules/auth/types/change_password_in'
import ResetPasswordIn from '@/modules/auth/types/reset_password_in'

export function useAuthService() {
  const { loading, error, request } = useApi()

  async function login(data: LoginIn) {
    return await request({
      url: API_ENDPOINTS.auth.login,
      method: 'POST',
      data
    })
  }

  async function changePassword(data: ChangePasswordIn) {
    return await request({
      url: API_ENDPOINTS.auth.changePassword,
      method: 'PUT',
      data
    })
  }

  async function resetPassword(data: ResetPasswordIn) {
    return await request({
      url: API_ENDPOINTS.auth.resetPassword,
      method: 'PUT',
      data
    })
  }

  return { loading, error, login, changePassword, resetPassword }
} 