// Admin Workshop Configuration
export const adminWorkshopConfig = {
  // Permisos de visualización
  canViewDetails: true,
  canCreate: true,
  canEdit: true,
  canDelete: true,
  canManageInscriptions: true,
  canManageGrades: true,
  canExportData: true,
  
  // Campos visibles
  visibleFields: [
    'id',
    'name',
    'description',
    'professor',
    'startDate',
    'endDate',
    'schedule',
    'status',
    'inscriptionCount',
    'maxInscriptions',
    'createdAt',
    'updatedAt'
  ],
  
  // Acciones disponibles
  availableActions: [
    'view',
    'create',
    'edit',
    'delete',
    'manageInscriptions',
    'manageGrades',
    'exportInscriptions',
    'exportGrades',
    'exportReport'
  ],
  
  // Estados para gestión
  manageableStates: ['INSCRIPCION', 'EN_CURSO', 'FINALIZADO'],
  
  // Filtros por defecto
  defaultFilters: {
    status: 'active' // Filtra por talleres activos
  }
} 