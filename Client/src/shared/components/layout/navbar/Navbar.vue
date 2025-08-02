<template>
  <header class="bg-card border-b border-border px-6 py-4">
    <div class="flex items-center justify-between">
      <!-- Left Section -->
      <div class="flex items-center space-x-4">
        <!-- Mobile Menu Button -->
        <button
          v-if="showMobileMenu"
          @click="$emit('toggle-sidebar')"
          class="lg:hidden p-2 rounded-md hover:bg-accent hover:text-accent-foreground transition-colors"
        >
          <Icon name="mdi:menu" class="w-5 h-5" />
        </button>

        <!-- Breadcrumb -->
        <nav v-if="breadcrumbs.length > 0" class="hidden sm:flex items-center space-x-2">
          <template v-for="(crumb, index) in breadcrumbs" :key="index">
            <router-link
              v-if="crumb.to && index < breadcrumbs.length - 1"
              :to="crumb.to"
              class="text-sm text-muted-foreground hover:text-foreground transition-colors"
            >
              {{ crumb.label }}
            </router-link>
            <span v-else class="text-sm text-foreground font-medium">
              {{ crumb.label }}
            </span>
            <Icon 
              v-if="index < breadcrumbs.length - 1"
              name="mdi:chevron-right" 
              class="w-4 h-4 text-muted-foreground" 
            />
          </template>
        </nav>
      </div>

      <!-- Right Section -->
      <div class="flex items-center space-x-4">
        <!-- Search (if enabled) -->
        <div v-if="showSearch" class="relative hidden md:block">
          <Icon 
            name="mdi:magnify" 
            class="absolute left-3 top-1/2 transform -translate-y-1/2 w-4 h-4 text-muted-foreground" 
          />
          <input
            v-model="searchQuery"
            type="text"
            placeholder="Buscar..."
            class="pl-10 pr-4 py-2 w-64 bg-background border border-input rounded-md text-sm focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent"
            @input="$emit('search', searchQuery)"
          />
        </div>

        <!-- Notifications -->
        <button
          v-if="showNotifications"
          @click="$emit('toggle-notifications')"
          class="relative p-2 rounded-md hover:bg-accent hover:text-accent-foreground transition-colors"
        >
          <Icon name="mdi:bell-outline" class="w-5 h-5" />
          <span
            v-if="notificationCount > 0"
            class="absolute -top-1 -right-1 w-5 h-5 bg-destructive text-destructive-foreground text-xs rounded-full flex items-center justify-center"
          >
            {{ notificationCount > 99 ? '99+' : notificationCount }}
          </span>
        </button>

        <!-- Theme Toggle -->
        <ThemeToggle v-if="showThemeToggle" />

        <!-- User Menu -->
        <div v-if="userInfo" class="relative">
          <button
            @click="toggleUserMenu"
            class="flex items-center space-x-2 p-2 rounded-md hover:bg-accent hover:text-accent-foreground transition-colors"
          >
            <div class="w-8 h-8 rounded-full bg-primary flex items-center justify-center">
              <Icon name="mdi:account" class="w-5 h-5 text-primary-foreground" />
            </div>
            <span v-if="showUserInfo" class="hidden sm:block text-sm font-medium text-foreground">
              {{ userInfo.name }}
            </span>
            <Icon 
              name="mdi:chevron-down" 
              class="w-4 h-4 text-muted-foreground" 
            />
          </button>

          <!-- User Dropdown -->
          <div
            v-if="isUserMenuOpen"
            class="absolute right-0 mt-2 w-48 bg-card border border-border rounded-md shadow-lg z-50"
          >
            <div class="py-1">
              <router-link
                v-for="item in userMenuItems"
                :key="item.label"
                :to="item.to"
                @click="isUserMenuOpen = false"
                class="flex items-center px-4 py-2 text-sm text-foreground hover:bg-accent hover:text-accent-foreground transition-colors"
              >
                <Icon :name="item.icon" class="w-4 h-4 mr-3" />
                {{ item.label }}
              </router-link>
              <button
                @click="handleLogout"
                class="w-full flex items-center px-4 py-2 text-sm text-destructive hover:bg-destructive hover:text-destructive-foreground transition-colors"
              >
                <Icon name="mdi:logout" class="w-4 h-4 mr-3" />
                Cerrar Sesión
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </header>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { Icon } from '@iconify/vue'
import ThemeToggle from './ThemeToggle.vue'
import type { Breadcrumb, UserInfo, UserMenuItem } from '../types/layout_config'

interface Props {
  breadcrumbs?: Breadcrumb[]
  userInfo?: UserInfo
  showMobileMenu?: boolean
  showSearch?: boolean
  showNotifications?: boolean
  showThemeToggle?: boolean
  showUserInfo?: boolean
  notificationCount?: number
  userMenuItems?: UserMenuItem[]
}

const props = withDefaults(defineProps<Props>(), {
  breadcrumbs: () => [],
  showMobileMenu: true,
  showSearch: false,
  showNotifications: true,
  showThemeToggle: true,
  showUserInfo: true,
  notificationCount: 0,
  userMenuItems: () => [
    { label: 'Mi Perfil', to: '/profile', icon: 'mdi:account-circle' },
    { label: 'Configuración', to: '/settings', icon: 'mdi:cog' }
  ]
})

const emit = defineEmits<{
  'toggle-sidebar': []
  'toggle-notifications': []
  'search': [query: string]
  'logout': []
}>()

const searchQuery = ref('')
const isUserMenuOpen = ref(false)

const toggleUserMenu = () => {
  isUserMenuOpen.value = !isUserMenuOpen.value
}

const handleLogout = () => {
  isUserMenuOpen.value = false
  emit('logout')
}

// Close user menu when clicking outside
const handleClickOutside = (event: Event) => {
  const target = event.target as Element
  if (!target.closest('.relative')) {
    isUserMenuOpen.value = false
  }
}

// Add click outside listener
if (typeof window !== 'undefined') {
  document.addEventListener('click', handleClickOutside)
}
</script>
