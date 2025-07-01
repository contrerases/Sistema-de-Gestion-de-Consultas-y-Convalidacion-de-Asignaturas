// Configuración de la API
export const API_CONFIG = {
  BASE_URL: import.meta.env.VITE_API_BASE_URL || 'http://localhost:3000/api',
  TIMEOUT: 10000,
  RETRY_ATTEMPTS: 3,
  RETRY_DELAY: 1000,
}

// Endpoints de la API
export const API_ENDPOINTS = {
  // Autenticación
  AUTH: {
    LOGIN: '/auth/login',
    LOGOUT: '/auth/logout',
    REFRESH: '/auth/refresh',
    PROFILE: '/auth/profile',
  },

  // Usuarios
  USERS: {
    BASE: '/users',
    PROFILE: '/users/profile',
    UPDATE_PROFILE: '/users/profile/update',
  },

  // Solicitudes
  REQUESTS: {
    BASE: '/requests',
    PENDING: '/requests/pending',
    APPROVED: '/requests/approved',
    REJECTED: '/requests/rejected',
    BY_USER: '/requests/user',
    CREATE: '/requests/create',
    UPDATE: '/requests/update',
    DELETE: '/requests/delete',
  },

  // Convalidaciones
  CONVALIDATIONS: {
    BASE: '/convalidations',
    BY_REQUEST: '/convalidations/request',
    CREATE: '/convalidations/create',
    UPDATE: '/convalidations/update',
    DELETE: '/convalidations/delete',
  },

  // Talleres
  WORKSHOPS: {
    BASE: '/workshops',
    CURRENT: '/workshops/current',
    PAST: '/workshops/past',
    UPCOMING: '/workshops/upcoming',
    CREATE: '/workshops/create',
    UPDATE: '/workshops/update',
    DELETE: '/workshops/delete',
    INSCRIPTIONS: '/workshops/inscriptions',
  },

  // Asignaturas
  SUBJECTS: {
    BASE: '/subjects',
    CREATE: '/subjects/create',
    UPDATE: '/subjects/update',
    DELETE: '/subjects/delete',
  },

  // Cursos del currículum
  CURRICULUM_COURSES: {
    BASE: '/curriculum-courses',
    CREATE: '/curriculum-courses/create',
    UPDATE: '/curriculum-courses/update',
    DELETE: '/curriculum-courses/delete',
  },

  // Departamentos
  DEPARTMENTS: {
    BASE: '/departments',
    CREATE: '/departments/create',
    UPDATE: '/departments/update',
    DELETE: '/departments/delete',
  },

  // Tipos
  TYPES: {
    CONVALIDATION: '/types/convalidation',
    CURRICULUM_COURSE: '/types/curriculum-course',
  },

  // Estadísticas
  STATS: {
    DASHBOARD: '/stats/dashboard',
    REQUESTS: '/stats/requests',
    WORKSHOPS: '/stats/workshops',
    CONVALIDATIONS: '/stats/convalidations',
  },
}

// Headers por defecto
export const DEFAULT_HEADERS = {
  'Content-Type': 'application/json',
  'Accept': 'application/json',
}

// Códigos de estado HTTP
export const HTTP_STATUS = {
  OK: 200,
  CREATED: 201,
  NO_CONTENT: 204,
  BAD_REQUEST: 400,
  UNAUTHORIZED: 401,
  FORBIDDEN: 403,
  NOT_FOUND: 404,
  CONFLICT: 409,
  UNPROCESSABLE_ENTITY: 422,
  INTERNAL_SERVER_ERROR: 500,
} as const

// Mensajes de error comunes
export const ERROR_MESSAGES = {
  NETWORK_ERROR: 'Error de conexión. Verifique su conexión a internet.',
  TIMEOUT_ERROR: 'La solicitud ha tardado demasiado. Inténtelo de nuevo.',
  UNAUTHORIZED: 'No tiene permisos para realizar esta acción.',
  NOT_FOUND: 'El recurso solicitado no fue encontrado.',
  VALIDATION_ERROR: 'Los datos proporcionados no son válidos.',
  SERVER_ERROR: 'Error interno del servidor. Inténtelo más tarde.',
  UNKNOWN_ERROR: 'Ha ocurrido un error inesperado.',
} as const 