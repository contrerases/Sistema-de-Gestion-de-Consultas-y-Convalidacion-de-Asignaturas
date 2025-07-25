
export default interface ChangePasswordIn {
  id_auth_user: number
  current_password_hash: string
  new_password_hash: string
} 