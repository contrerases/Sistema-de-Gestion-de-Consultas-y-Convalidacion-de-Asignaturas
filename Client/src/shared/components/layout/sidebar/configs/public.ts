import type { SidebarItem } from '../types/sidebar-items'

export const publicMenu: SidebarItem[] = [
  { to: '/', label: 'Inicio', icon: 'mdi:home' },
  { to: '/login', label: 'Iniciar sesión', icon: 'mdi:login' },
  { to: '/change-password', label: 'Cambiar contraseña', icon: 'mdi:key-change' },
  { to: '/help', label: 'Ayuda', icon: 'mdi:help-circle' },
]

export default publicMenu 