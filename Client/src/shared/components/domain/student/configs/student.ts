// Student Profile Configuration
export const studentStudentConfig = {
  // Permisos de visualización
  canViewDetails: true,
  canEdit: true,
  canViewHistory: true,
  canViewProgress: true,
  
  // Campos visibles
  visibleFields: [
    'name',
    'rut',
    'email',
    'department',
    'academicProgress',
    'convalidationsCount',
    'workshopsCount'
  ],
  
  // Acciones disponibles
  availableActions: [
    'view',
    'edit',
    'changePassword'
  ],
  
  // Filtros por defecto
  defaultFilters: {
    studentId: 'current' // Solo datos del estudiante actual
  }
} 