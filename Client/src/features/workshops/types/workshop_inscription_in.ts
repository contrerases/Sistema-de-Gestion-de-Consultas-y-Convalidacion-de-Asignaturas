// workshop_inscription_in.ts
// Interface de inscripción a taller (input) basada en IN del backend

export interface WorkshopInscriptionCreateIn {
  id_workshop: number
  id_student: number
  is_convalidated: boolean
  id_curriculum_course: number
}

export interface WorkshopInscriptionUpdateIn extends WorkshopInscriptionCreateIn {
  id_inscription: number
} 