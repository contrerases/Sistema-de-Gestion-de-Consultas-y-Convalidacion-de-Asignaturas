// Student Notification Configuration
export const studentNotificationConfig = {
  // Permisos de visualización
  canViewDetails: true,
  canMarkAsRead: true,
  canDelete: true,
  
  // Campos visibles
  visibleFields: [
    'id',
    'title',
    'message',
    'type',
    'createdAt',
    'isRead'
  ],
  
  // Acciones disponibles
  availableActions: [
    'view',
    'markAsRead',
    'delete'
  ],
  
  // Filtros por defecto
  defaultFilters: {
    userId: 'current', // Solo notificaciones del usuario actual
    isRead: false // Filtra por no leídas por defecto
  }
} 