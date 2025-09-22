// workshop_grade_out.ts
// Interface de calificación de taller (output) basada en OUT del backend

export interface WorkshopGradeOut {
  id_grade: number
  id_workshop: number
  workshop: string
  id_student: number
  rut_student: string
  semester: string
  year: number
  grade: number
} 