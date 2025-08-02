import type { SidebarItem } from '../types/sidebar-items'

export const adminMenu: SidebarItem[] = [
  {
    to: '/admin/dashboard',
    label: 'Dashboard',
    icon: 'mdi:view-dashboard',
  },
  {
    label: 'Convalidaciones',
    icon: 'mdi:file-document-edit-outline',
    children: [
      {
        to: '/admin/convalidaciones/pendientes',
        label: 'Solicitudes Pendientes',
        icon: 'mdi:file-document-edit-outline',
      },
      {
        to: '/admin/convalidaciones/historial',
        label: 'Historial de Trámites',
        icon: 'mdi:history',
      },
    ],
  },
  {
    label: 'Talleres',
    icon: 'mdi:clipboard-list-outline',
    children: [
      {
        to: '/admin/talleres',
        label: 'Gestionar Talleres',
        icon: 'mdi:clipboard-list-outline',
      },
      {
        to: '/admin/talleres/inscripciones',
        label: 'Gestionar Inscripciones',
        icon: 'mdi:account-multiple-check-outline',
      },
    ],
  },
  {
    to: '/admin/catalogo',
    label: 'Catálogo de Asignaturas',
    icon: 'mdi:book-open-variant',
  },
  {
    to: '/admin/usuarios',
    label: 'Gestión de Usuarios',
    icon: 'mdi:account-group-outline',
  },
]