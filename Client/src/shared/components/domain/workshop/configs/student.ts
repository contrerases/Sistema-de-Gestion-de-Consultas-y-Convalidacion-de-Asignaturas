// Student Workshop Configuration
export const studentWorkshopConfig = {
  // Permisos de visualización
  canViewDetails: true,
  canInscribe: true,
  canCancelInscription: true,
  canViewGrades: true,
  canManageWorkshop: false,
  
  // Campos visibles
  visibleFields: [
    'name',
    'description',
    'professor',
    'startDate',
    'endDate',
    'schedule',
    'status',
    'inscriptionStatus'
  ],
  
  // Acciones disponibles
  availableActions: [
    'view',
    'inscribe',
    'cancelInscription',
    'downloadSyllabus',
    'viewGrades'
  ],
  
  // Estados para inscripción
  inscribableStates: ['INSCRIPCION'],
  
  // Estados para cancelación
  cancellableStates: ['INSCRIPCION'],
  
  // Filtros por defecto
  defaultFilters: {
    status: 'available' // Filtra por talleres disponibles
  }
} 