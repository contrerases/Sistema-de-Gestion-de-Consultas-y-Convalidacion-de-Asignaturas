// Modelo base para WorkshopsInscriptions
export interface WorkshopsInscriptionsBase {
    id: number;
    id_student: number;
    id_workshop: number;
    id_curriculum_course: number  | null;
    is_convalidated: boolean;
  }

  // Modelo para insertar una nueva inscripción
  export interface WorkshopsInscriptionsPost {
    id_student: number;
    id_workshop: number;
    id_curriculum_course: number | null;
    is_convalidated: boolean;
  }

  // Modelo para la respuesta de una actualización de inscripción
  export interface WorkshopsInscriptionsResponse {
    id: number;
    id_student: number;
    name_student: string; // Nombre Apellido
    rut_student: string;
    id_workshop: number;
    workshop: string;
    id_curriculum_course: number | null; // Optional property
    curriculum_course: string | null; // Optional property
    is_convalidated: boolean;
  }
