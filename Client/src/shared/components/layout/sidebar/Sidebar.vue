<template>
  <aside 
    class="bg-card border-r border-border h-screen transition-all duration-300"
    :class="[
      isCollapsed ? 'w-16' : 'w-64',
      'flex flex-col'
    ]"
  >
    <!-- Logo/Brand -->
    <div class="p-4 border-b border-border">
      <div class="flex items-center justify-between">
        <div v-if="!isCollapsed" class="flex items-center space-x-2">
          <img src="@/assets/img/logo.png" alt="Logo" class="w-8 h-8" />
          <span class="text-lg font-semibold text-foreground">Sistema</span>
        </div>
        <button
          @click="toggleCollapse"
          class="p-1 rounded-md hover:bg-accent hover:text-accent-foreground transition-colors"
          :title="isCollapsed ? 'Expandir' : 'Colapsar'"
        >
          <Icon 
            :name="isCollapsed ? 'mdi:chevron-right' : 'mdi:chevron-left'" 
            class="w-5 h-5" 
          />
        </button>
      </div>
    </div>

    <!-- Navigation Menu -->
    <nav class="flex-1 overflow-y-auto py-4">
      <ul class="space-y-1 px-2">
        <li v-for="item in menuItems" :key="item.label">
          <SidebarItem 
            :item="item" 
            :is-collapsed="isCollapsed"
            :is-active="isActiveRoute(item.to)"
          />
        </li>
      </ul>
    </nav>

    <!-- User Profile Section -->
    <div v-if="userInfo" class="p-4 border-t border-border">
      <div class="flex items-center space-x-3">
        <div class="w-8 h-8 rounded-full bg-primary flex items-center justify-center">
          <Icon name="mdi:account" class="w-5 h-5 text-primary-foreground" />
        </div>
        <div v-if="!isCollapsed" class="flex-1 min-w-0">
          <p class="text-sm font-medium text-foreground truncate">
            {{ userInfo.name }}
          </p>
          <p class="text-xs text-muted-foreground truncate">
            {{ userInfo.role }}
          </p>
        </div>
      </div>
    </div>
  </aside>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useRoute } from 'vue-router'
import { Icon } from '@iconify/vue'
import SidebarItem from './SidebarItem.vue'
import type { SidebarItem as SidebarItemType } from '../types/sidebar_items'
import type { UserInfo } from '../types/layout_config'

interface Props {
  menuItems: SidebarItemType[]
  userInfo?: UserInfo
  collapsed?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  collapsed: false
})

const emit = defineEmits<{
  'update:collapsed': [value: boolean]
}>()

const route = useRoute()
const isCollapsed = ref(props.collapsed)

const toggleCollapse = () => {
  isCollapsed.value = !isCollapsed.value
  emit('update:collapsed', isCollapsed.value)
}

const isActiveRoute = (to?: string): boolean => {
  if (!to) return false
  return route.path.startsWith(to)
}
</script>
