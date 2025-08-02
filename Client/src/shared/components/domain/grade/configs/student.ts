// Student Grade Configuration
export const studentGradeConfig = {
  // Permisos de visualización
  canViewDetails: true,
  canViewHistory: true,
  canExportGrades: true,
  
  // Campos visibles
  visibleFields: [
    'workshopName',
    'grade',
    'maxGrade',
    'percentage',
    'evaluatedAt',
    'comments'
  ],
  
  // Acciones disponibles
  availableActions: [
    'view',
    'export'
  ],
  
  // Filtros por defecto
  defaultFilters: {
    studentId: 'current' // Solo calificaciones del estudiante actual
  }
} 