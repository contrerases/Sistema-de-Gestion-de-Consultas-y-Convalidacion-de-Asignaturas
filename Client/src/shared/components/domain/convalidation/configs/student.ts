// Student Convalidation Configuration
export const studentConvalidationConfig = {
  // Permisos de visualización
  canViewDetails: true,
  canEdit: false,
  canDelete: true, // Solo convalidaciones no revisadas
  canApprove: false,
  canReject: false,
  
  // Campos visibles
  visibleFields: [
    'id',
    'type',
    'subject',
    'status',
    'createdAt',
    'comments'
  ],
  
  // Acciones disponibles
  availableActions: [
    'view',
    'delete'
  ],
  
  // Estados permitidos para eliminación
  deletableStates: ['ENVIADA'],
  
  // Filtros por defecto
  defaultFilters: {
    studentId: 'current' // Filtra por estudiante actual
  }
} 