// Admin Grade Configuration
export const adminGradeConfig = {
  // Permisos de visualización
  canViewDetails: true,
  canCreate: true,
  canEdit: true,
  canDelete: true,
  canBulkUpload: true,
  canExportGrades: true,
  
  // Campos visibles
  visibleFields: [
    'id',
    'studentName',
    'studentRut',
    'workshopName',
    'grade',
    'maxGrade',
    'percentage',
    'evaluatedAt',
    'evaluatedBy',
    'comments'
  ],
  
  // Acciones disponibles
  availableActions: [
    'view',
    'create',
    'edit',
    'delete',
    'bulkUpload',
    'export'
  ],
  
  // Filtros por defecto
  defaultFilters: {
    workshopId: 'all' // Filtra por todos los talleres
  }
} 