// workshop_out.ts
// Interface de taller (output) basada en WorkshopOut del backend

export interface WorkshopOut {
  id_workshop: number
  workshop: string
  semester: string
  year: number
  professor: string
  description: string
  inscription_start_date: string // datetime
  inscription_end_date: string // datetime
  course_start_date: string // datetime
  course_end_date: string // datetime
  available: boolean
  limit_inscriptions: number
  id_workshop_state: number
  workshop_state: string
  inscriptions_count: number
} 