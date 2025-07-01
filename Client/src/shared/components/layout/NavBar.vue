<script setup lang="ts">
import { ref, onMounted, onBeforeUnmount } from 'vue'
import { useRouter } from 'vue-router'
import { Icon } from "@iconify/vue"
import { Button,  ColorMode } from '@/shared/components/ui'


import { useAuthStore } from '@/shared/stores/auth_store'
import { useRequestStore } from '@/shared/stores/request_store'

// Composables
const authStore = useAuthStore()
const requestStore = useRequestStore()
const router = useRouter()

// Estado reactivo
const isOpen = ref(false)
const dropdownRef = ref<HTMLElement | null>(null)
const tooltipVisible = ref(false)
const tooltipRef = ref<HTMLElement | null>(null)
const countPendingRequests = ref(0)

// Métodos
const toggleMenu = () => {
  isOpen.value = !isOpen.value
}

const closeMenu = () => {
  isOpen.value = false
}

const handleClickOutsideMenu = (event: MouseEvent) => {
  if (dropdownRef.value && !dropdownRef.value.contains(event.target as Node)) {
    closeMenu()
  }
}

const handleClickOutsideTooltip = (event: MouseEvent) => {
  if (tooltipRef.value && !tooltipRef.value.contains(event.target as Node)) {
    closeTooltip()
  }
}

const closeTooltip = () => {
  tooltipVisible.value = false
}

const toggleTooltip = () => {
  tooltipVisible.value = !tooltipVisible.value
}

const countPendingRequestsHandler = async () => {
  await requestStore.getSendRequestsStore()
  countPendingRequests.value = requestStore.count_pending_requests
}

const logout = () => {
  authStore.clearUser()
  closeMenu()
  router.push({ name: 'home' })
}

// Lifecycle
onMounted(() => {
  countPendingRequestsHandler()
  document.addEventListener('click', handleClickOutsideMenu)
  document.addEventListener('click', handleClickOutsideTooltip)
})

onBeforeUnmount(() => {
  document.removeEventListener('click', handleClickOutsideMenu)
  document.removeEventListener('click', handleClickOutsideTooltip)
})
</script>

<template>
  <nav class="flex items-center justify-between w-full h-16 px-6 border-b border-border bg-background">
    <!-- Logo y título -->
    <div class="flex items-center space-x-4">
      <img src="@/assets/img/DI_IMG.png" alt="Logo" class="w-16 h-12 object-contain">
      <h1 class="text-lg font-bold text-foreground font-mono">
        Departamento de Informática
      </h1>
    </div>

    <!-- Acciones del usuario -->
    <div class="flex items-center space-x-4">
      <!-- Notificaciones para administradores -->
      <div v-if="authStore.isAdmin" class="relative" ref="tooltipRef">
        <Button
          variant="ghost"
          size="icon"
          @click="toggleTooltip"
          class="relative"
        >
          <Icon icon="ci:notification" class="w-5 h-5" />
          <Badge
            v-if="countPendingRequests !== 0"
            variant="destructive"
            size="sm"
            class="absolute -top-1 -right-1 min-w-[20px] h-5 flex items-center justify-center"
          >
            {{ countPendingRequests }}
          </Badge>
        </Button>

        <!-- Tooltip de notificaciones -->
        <div
          v-if="tooltipVisible && countPendingRequests !== 0"
          class="absolute right-0 mt-2 p-3 text-sm text-white bg-popover border border-border rounded-lg shadow-lg z-50 min-w-[200px]"
        >
          <p class="font-medium mb-1">Notificaciones</p>
          <p>Tiene {{ countPendingRequests }} solicitudes sin revisar.</p>
        </div>
      </div>

      <!-- Selector de tema -->
      <ColorMode />

      <!-- Menú de usuario -->
      <div class="relative" ref="dropdownRef">
        <div v-if="authStore.isAuthenticated">
          <Button
            variant="outline"
            @click="toggleMenu"
            class="flex items-center space-x-2"
          >
            <span class="font-medium">{{ authStore.username }}</span>
            <Icon 
              icon="teenyicons:down-small-outline" 
              class="w-4 h-4 transition-transform duration-200"
              :class="{ 'rotate-180': isOpen }"
            />
          </Button>

          <!-- Dropdown menu -->
          <div
            v-if="isOpen"
            class="absolute right-0 mt-2 w-48 bg-popover border border-border rounded-lg shadow-lg z-50"
          >
            <div class="p-1">
              <Button
                variant="ghost"
                class="w-full justify-start"
                @click="logout"
              >
                <Icon icon="lucide:log-out" class="w-4 h-4 mr-2" />
                Cerrar sesión
              </Button>
            </div>
          </div>
        </div>

        <!-- Botón de inicio de sesión -->
        <div v-else>
          <Button
            variant="outline"
            @click="toggleMenu"
            class="font-medium"
          >
            Iniciar sesión
          </Button>
        </div>
      </div>
    </div>
  </nav>
</template>

<style scoped>
/* Estilos adicionales si se requieren */
</style>
