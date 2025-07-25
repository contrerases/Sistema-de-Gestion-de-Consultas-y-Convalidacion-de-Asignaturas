export default interface ConvalidationIn {
  id_student: number
  id_convalidation_type: number
  id_curriculum_course: number
  id_workshop?: number
  id_activity_name?: number
  id_subject?: number
  description: string
  file_name?: string
  file_data?: string
  id_department?: number
}

