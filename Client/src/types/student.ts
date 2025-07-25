// Types para estudiantes basados en los schemas del backend

export interface StudentOut {
  id_student: number
  name_student: string
  rol_student: string
  rut_student: string
  campus_student: string
  email_student: string
}

export interface StudentCreateIn {
  first_names: string
  last_names: string
  campus: string
  rol_student: string
  rut_student: string
  campus_student: string
  email: string
  password_hash: string
}

export interface StudentUpdateIn extends StudentCreateIn {
  id_student: number
} 