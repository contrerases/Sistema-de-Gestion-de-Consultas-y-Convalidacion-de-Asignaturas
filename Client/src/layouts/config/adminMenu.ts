import type { SidebarItem } from '../types/sidebar'

export const adminMenu: SidebarItem[] = [
  { to: '/admin/dashboard', label: 'Dashboard', icon: 'mdi:view-dashboard' },
  { to: '/admin/users', label: 'Usuarios', icon: 'mdi:account-group' },
  { to: '/admin/workshops', label: 'Talleres', icon: 'mdi:hammer-wrench' },
  { to: '/admin/convalidations', label: 'Convalidaciones', icon: 'mdi:swap-horizontal' },
  { to: '/admin/catalogs', label: 'Catálogos', icon: 'mdi:book-open-variant' },
]

export default adminMenu 