import { RequestStates } from '@/shared/enums/request_states'
import { UserRoles } from '@/shared/enums/user_roles'
import { CourseConvalidationTypes } from '@/shared/enums/courses_convalidation_types'

// Constantes de la aplicación
export const APP_CONFIG = {
  NAME: 'Sistema de Gestión de Convalidaciones y Talleres',
  VERSION: '1.0.0',
  DESCRIPTION: 'Sistema para gestionar convalidaciones y talleres del Departamento de Informática',
}

// Roles de usuario (para guards, menús, lógica de permisos)
export const USER_ROLES = UserRoles;



// Tipos de convalidación
export const CONVALIDATION_TYPES = {
  INTERNAL: 'internal',
  EXTERNAL: 'external',
  WORKSHOP: 'workshop',
  PROJECT: 'project',
  CERTIFICATE: 'certificate',
} as const

// Estados de talleres
export const WORKSHOP_STATUS = {
  DRAFT: 'draft',
  PUBLISHED: 'published',
  IN_PROGRESS: 'in_progress',
  COMPLETED: 'completed',
  CANCELLED: 'cancelled',
} as const

// Estados de inscripciones a talleres
export const WORKSHOP_INSCRIPTION_STATUS = {
  PENDING: 'pending',
  CONFIRMED: 'confirmed',
  CANCELLED: 'cancelled',
  COMPLETED: 'completed',
} as const

// Límites de paginación
export const PAGINATION = {
  DEFAULT_PAGE_SIZE: 10,
  MAX_PAGE_SIZE: 100,
  PAGE_SIZE_OPTIONS: [5, 10, 20, 50, 100],
} as const

// Labels y colores para estados de solicitud/convalidación
export const REQUEST_STATUS_LABELS = {
  [RequestStates.ENVIADA]: 'Enviada',
  [RequestStates.RECHAZADA]: 'Rechazada',
  [RequestStates.APROBADA_DI]: 'Aprobada por DI',
  [RequestStates.EN_ESPERA_DE]: 'En espera de DE',
  [RequestStates.APROBADA_DE]: 'Aprobada por DE',
} as const;

export const REQUEST_STATUS_COLORS = {
  [RequestStates.ENVIADA]: 'gray',
  [RequestStates.RECHAZADA]: 'red',
  [RequestStates.APROBADA_DI]: 'blue',
  [RequestStates.EN_ESPERA_DE]: 'yellow',
  [RequestStates.APROBADA_DE]: 'green',
} as const;

// Tipos de convalidación (labels para la UI)
export const CONVALIDATION_TYPE_LABELS = {
  [CourseConvalidationTypes.ELECTIVO_DI]: 'Electivo DI',
  [CourseConvalidationTypes.ELECTIVO_EXTERNO]: 'Electivo Externo',
  [CourseConvalidationTypes.CURSO_CERTIFICADO]: 'Curso Certificado',
  [CourseConvalidationTypes.TALLER_INF]: 'Taller de INF',
  [CourseConvalidationTypes.PROYECTO_PERSONAL]: 'Proyecto Personal',
} as const;



// Iconos realmente usados en la app
export const ICONS = {
  HOME: 'material-symbols:home',
  DASHBOARD: 'gridicons:stats-alt',
  REQUESTS: 'lets-icons:order',
  HISTORY: 'ph:list-bullets-fill',
  WORKSHOPS: 'ic:baseline-library-books',
  COURSES: 'uiw:document',
  SUBJECTS: 'wpf:books',
  DEPARTMENTS: 'wpf:books',
  NOTIFICATION: 'ci:notification',
  LOGOUT: 'lucide:log-out',
  DROPDOWN: 'teenyicons:down-small-outline',
  UP_SMALL: 'teenyicons:up-small-outline',
  DOWN_SMALL: 'teenyicons:down-small-outline',
  PDF: 'dashicons:pdf',
  DOCUMENT: 'carbon:document',
  DELETE: 'material-symbols:delete',
  SETTING: 'uiw:setting',
  EDIT: 'akar-icons:pencil',
  CHEVRON_UP: 'lucide:chevron-up',
  CHEVRON_DOWN: 'lucide:chevron-down',
  CHEVRONS_UP_DOWN: 'lucide:chevrons-up-down',
  INBOX: 'lucide:inbox',
  CHEVRON_LEFT: 'lucide:chevron-left',
  CHEVRON_RIGHT: 'lucide:chevron-right',
} as const;

// Validaciones
export const VALIDATION = {
  MIN_PASSWORD_LENGTH: 8,
  MAX_PASSWORD_LENGTH: 128,
  MIN_NAME_LENGTH: 2,
  MAX_NAME_LENGTH: 100,
  MIN_DESCRIPTION_LENGTH: 10,
  MAX_DESCRIPTION_LENGTH: 1000,
  EMAIL_REGEX: /^[^\s@]+@[^\s@]+\.[^\s@]+$/,
  RUT_REGEX: /^\d{1,2}\.\d{3}\.\d{3}[-][0-9kK]{1}$/,
  PHONE_REGEX: /^\+?[\d\s\-\(\)]+$/,
} as const

// Formatos de fecha
export const DATE_FORMATS = {
  DISPLAY: 'DD/MM/YYYY',
  DISPLAY_WITH_TIME: 'DD/MM/YYYY HH:mm',
  API: 'YYYY-MM-DD',
  API_WITH_TIME: 'YYYY-MM-DDTHH:mm:ss',
} as const

// Rutas de navegación y nombres de rutas
export const ROUTES = {
  HOME: '/',
  LOGIN: '/login',
  ADMIN: '/admin',
  STUDENT: '/student',
  DASHBOARD: '/dashboard',
  REQUESTS: '/requests',
  WORKSHOPS: '/workshops',
  CONVALIDATIONS: '/convalidations',
  PROFILE: '/profile',
} as const

export const ROUTE_NAMES = {
  HOME: 'home',
  LOGIN: 'login',
  ADMIN: 'admin',
  STUDENT: 'student',
  DASHBOARD: 'dashboard',
  REQUESTS: 'requests',
  WORKSHOPS: 'workshops',
  CONVALIDATIONS: 'convalidations',
  PROFILE: 'profile',
} as const

// Mensajes de éxito y confirmación
export const SUCCESS_MESSAGES = {
  REQUEST_CREATED: 'Solicitud creada exitosamente',
  REQUEST_UPDATED: 'Solicitud actualizada exitosamente',
  REQUEST_DELETED: 'Solicitud eliminada exitosamente',
  WORKSHOP_CREATED: 'Taller creado exitosamente',
  WORKSHOP_UPDATED: 'Taller actualizado exitosamente',
  WORKSHOP_DELETED: 'Taller eliminado exitosamente',
  INSCRIPTION_CREATED: 'Inscripción realizada exitosamente',
  INSCRIPTION_CANCELLED: 'Inscripción cancelada exitosamente',
  PROFILE_UPDATED: 'Perfil actualizado exitosamente',
  LOGIN_SUCCESS: 'Inicio de sesión exitoso',
  LOGOUT_SUCCESS: 'Cierre de sesión exitoso',
} as const

export const CONFIRMATION_MESSAGES = {
  DELETE_REQUEST: '¿Está seguro de que desea eliminar esta solicitud?',
  DELETE_WORKSHOP: '¿Está seguro de que desea eliminar este taller?',
  CANCEL_INSCRIPTION: '¿Está seguro de que desea cancelar su inscripción?',
  LOGOUT: '¿Está seguro de que desea cerrar sesión?',
} as const 