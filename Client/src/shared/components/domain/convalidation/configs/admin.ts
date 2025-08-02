// Admin Convalidation Configuration
export const adminConvalidationConfig = {
  // Permisos de visualización
  canViewDetails: true,
  canEdit: true,
  canDelete: false,
  canApprove: true,
  canReject: true,
  
  // Campos visibles
  visibleFields: [
    'id',
    'studentName',
    'studentRut',
    'type',
    'subject',
    'status',
    'createdAt',
    'comments',
    'reviewer',
    'reviewedAt'
  ],
  
  // Acciones disponibles
  availableActions: [
    'view',
    'edit',
    'approve',
    'reject',
    'export'
  ],
  
  // Estados para revisión
  reviewableStates: ['ENVIADA', 'ENVIADA_DE'],
  
  // Filtros por defecto
  defaultFilters: {
    status: 'pending' // Filtra por pendientes por defecto
  }
} 