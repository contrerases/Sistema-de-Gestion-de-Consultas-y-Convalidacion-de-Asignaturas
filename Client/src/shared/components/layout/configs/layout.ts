import type { SidebarItem } from './sidebar_items'

export interface Breadcrumb {
  label: string
  to?: string
}

export interface UserInfo {
  name: string
  role: string
  avatar?: string
}

export interface UserMenuItem {
  label: string
  to: string
  icon: string
}

export interface SidebarConfig {
  menuItems: SidebarItem[]
  userInfo?: UserInfo
  collapsed?: boolean
}

export interface NavbarConfig {
  breadcrumbs?: Breadcrumb[]
  showMobileMenu?: boolean
  showSearch?: boolean
  showNotifications?: boolean
  showThemeToggle?: boolean
  showUserInfo?: boolean
  notificationCount?: number
  userMenuItems?: UserMenuItem[]
}

export interface LayoutConfig extends SidebarConfig, NavbarConfig {
  // Configuración adicional específica del layout
  theme?: 'light' | 'dark' | 'system'
  sidebarPosition?: 'left' | 'right'
  navbarHeight?: string
} 