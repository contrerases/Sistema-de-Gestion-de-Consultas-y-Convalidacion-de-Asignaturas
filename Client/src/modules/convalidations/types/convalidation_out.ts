// convalidation_out.ts
// Interface de convalidación (output) basada en ConvalidationOut del backend


export interface Convalidation {
  id_request: number
  id_student: number
  sent_at?: string // datetime
  reviewed_at?: string // datetime
  student_name: string
  student_rut: string
  student_rol: string
  student_campus: string
  id_reviewed_by?: number
  reviewed_by?: string
  id_convalidation: number
  review_comments?: string
  id_convalidation_type: number
  convalidation_type: string
  id_convalidation_state: number
  convalidation_state: string
  id_curriculum_course: number
  curriculum_course: string
}

export interface ConvalidationSubjectOut extends Convalidation {
  id_subject: number
  subject: string
  department: string
}

export interface ConvalidationWorkshopOut extends Convalidation {
  id_convalidation_workshop: number
  id_convalidation: number
  id_workshop: number
  workshop: string
  semester: string
  year: number
}

export interface ConvalidationExternalActivityOut extends Convalidation {
  id_convalidation_external_activity: number
  id_convalidation: number
  id_external_activity: number
  external_activity: string
  semester: string
  year: number
}
  
export interface ConvalidationOut {
  subject: [ConvalidationSubjectOut]
  workshop: ConvalidationWorkshopOut
  external_activity: ConvalidationExternalActivityOut
}