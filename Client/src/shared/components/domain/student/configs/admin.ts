// Admin Student Management Configuration
export const adminStudentConfig = {
  // Permisos de visualización
  canViewDetails: true,
  canCreate: true,
  canEdit: true,
  canDelete: true,
  canViewHistory: true,
  canViewProgress: true,
  canExportData: true,
  
  // Campos visibles
  visibleFields: [
    'id',
    'name',
    'rut',
    'email',
    'department',
    'status',
    'academicProgress',
    'convalidationsCount',
    'workshopsCount',
    'createdAt',
    'lastLogin'
  ],
  
  // Acciones disponibles
  availableActions: [
    'view',
    'create',
    'edit',
    'delete',
    'export',
    'resetPassword'
  ],
  
  // Filtros por defecto
  defaultFilters: {
    status: 'active' // Filtra por estudiantes activos
  }
} 