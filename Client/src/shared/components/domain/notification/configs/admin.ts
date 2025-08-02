// Admin Notification Configuration
export const adminNotificationConfig = {
  // Permisos de visualización
  canViewDetails: true,
  canCreate: true,
  canEdit: true,
  canDelete: true,
  canMarkAsRead: true,
  canSendToAll: true,
  
  // Campos visibles
  visibleFields: [
    'id',
    'title',
    'message',
    'type',
    'recipient',
    'createdAt',
    'isRead',
    'sender'
  ],
  
  // Acciones disponibles
  availableActions: [
    'view',
    'create',
    'edit',
    'delete',
    'markAsRead',
    'sendToAll'
  ],
  
  // Filtros por defecto
  defaultFilters: {
    isRead: false // Filtra por no leídas por defecto
  }
} 