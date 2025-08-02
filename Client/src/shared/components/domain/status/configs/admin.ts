// Admin Status Configuration
export const adminStatusConfig = {
  // Permisos de visualización
  canViewDetails: true,
  canViewSystemStatus: true,
  canViewStatistics: true,
  
  // Campos visibles
  visibleFields: [
    'totalStudents',
    'activeStudents',
    'convalidationsPending',
    'convalidationsApproved',
    'convalidationsRejected',
    'workshopsActive',
    'workshopsCompleted',
    'systemHealth',
    'lastBackup'
  ],
  
  // Acciones disponibles
  availableActions: [
    'view',
    'export'
  ],
  
  // Filtros por defecto
  defaultFilters: {
    period: 'current' // Filtra por período actual
  }
} 