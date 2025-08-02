import type { SidebarItem } from '../types/sidebar-items'

export const studentMenu: SidebarItem[] = [
  {
    to: '/student/dashboard',
    label: 'Dashboard',
    icon: 'mdi:home-account',
  },
  {
    label: 'Convalidaciones',
    icon: 'mdi:file-document-multiple-outline',
    children: [
      {
        to: '/student/convalidaciones/solicitar',
        label: 'Solicitar Convalidación',
        icon: 'mdi:file-document-plus-outline',
      },
      {
        to: '/student/convalidaciones/historial',
        label: 'Mis Solicitudes',
        icon: 'mdi:file-document-multiple-outline',
      },
    ],
  },
  {
    label: 'Talleres',
    icon: 'mdi:clipboard-search-outline',
    children: [
      {
        to: '/student/talleres',
        label: 'Talleres Disponibles',
        icon: 'mdi:clipboard-search-outline',
      },
      {
        to: '/student/talleres/inscripciones',
        label: 'Mis Inscripciones',
        icon: 'mdi:check-decagram-outline',
      },
    ],
  },
  {
    to: '/profile',
    label: 'Mi Perfil',
    icon: 'mdi:account-circle-outline',
  },
]

export default studentMenu