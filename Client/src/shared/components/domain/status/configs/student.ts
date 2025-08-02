// Student Status Configuration
export const studentStatusConfig = {
  // Permisos de visualización
  canViewDetails: true,
  canViewProgress: true,
  
  // Campos visibles
  visibleFields: [
    'academicProgress',
    'convalidationsPending',
    'convalidationsApproved',
    'convalidationsRejected',
    'workshopsInProgress',
    'workshopsCompleted',
    'totalCredits'
  ],
  
  // Acciones disponibles
  availableActions: [
    'view'
  ],
  
  // Filtros por defecto
  defaultFilters: {
    studentId: 'current' // Solo estados del estudiante actual
  }
} 