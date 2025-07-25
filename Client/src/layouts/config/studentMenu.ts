import type { SidebarItem } from '../types/sidebar'

export const studentMenu: SidebarItem[] = [
  { to: '/student/profile', label: 'Perfil', icon: 'mdi:account' },
  { to: '/student/convalidations', label: 'Convalidaciones', icon: 'mdi:swap-horizontal' },
  { to: '/student/workshops', label: 'Talleres', icon: 'mdi:school' },
  { to: '/student/help', label: 'Ayuda', icon: 'mdi:help-circle' },
]

export default studentMenu 