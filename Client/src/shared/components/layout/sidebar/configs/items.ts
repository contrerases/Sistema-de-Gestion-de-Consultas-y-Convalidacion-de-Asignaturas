export interface SidebarItem {
  to?: string
  label: string
  icon: string
  children?: SidebarItem[]
  badge?: string | number
  disabled?: boolean
  permission?: string // Para control de acceso
} 