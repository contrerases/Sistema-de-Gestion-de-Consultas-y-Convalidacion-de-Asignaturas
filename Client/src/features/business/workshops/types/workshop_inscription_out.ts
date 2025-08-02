// workshop_inscription_out.ts
// Interface de inscripción a taller (output) basada en OUT del backend

export interface WorkshopInscriptionOut {
  id_inscription: number
  id_workshop: number
  id_student: number
  rut_student: string
  semester: string
  year: number
  is_convalidated: boolean
  id_curriculum_course: number
  curriculum_course: string
} 