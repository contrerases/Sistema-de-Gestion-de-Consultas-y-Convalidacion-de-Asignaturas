export default interface AuthUserOut {
  id_auth_user: number
  email: string
  id_user: number
  first_names: string
  last_names: string
  common_name: string
  full_name: string
  campus: string
  created_at: string // datetime
  updated_at: string // datetime
  user_type: string
  id_student?: number
  rol_student?: string
  rut_student?: string
  campus_student?: string
  id_admin?: number
} 