<script setup lang="ts">
import ColorMode from '@/components/ColorMode.vue';
import { Icon } from "@iconify/vue";
import { ref, onMounted, onBeforeUnmount } from 'vue';
import { useAuthStore } from '@/stores/auth_store';
import { useRequestStore } from '@/stores/request_store';

const auth_store = useAuthStore();
const request_store = useRequestStore();

const isOpen = ref(false);
const dropdownRef = ref<HTMLElement | null>(null);
const tooltipVisible = ref(false);
const tooltipRef = ref<HTMLElement | null>(null);
const count_pending_requests = ref(0);

// Función para alternar el menú
const toggleMenu = () => {
  isOpen.value = !isOpen.value;
};

// Función para cerrar el menú
const closeMenu = () => {
  isOpen.value = false;
};

// Función para manejar clics fuera del menú
const handleClickOutsideMenu = (event: MouseEvent) => {
  if (dropdownRef.value && !dropdownRef.value.contains(event.target as Node)) {
    closeMenu();
  }
};

// Función para manejar clics fuera del tooltip
const handleClickOutsideTooltip = (event: MouseEvent) => {
  if (tooltipRef.value && !tooltipRef.value.contains(event.target as Node)) {
    closeTooltip();
  }
};

// Función para cerrar el tooltip
const closeTooltip = () => {
  tooltipVisible.value = false;
};

// Función para alternar el tooltip
const toggleTooltip = () => {
  tooltipVisible.value = !tooltipVisible.value;
};

// Función para contar solicitudes pendientes
async function CountPendingRequestsHandler() {
  await request_store.getSendRequestsStore();
  count_pending_requests.value = request_store.count_pending_requests;
}

onMounted(() => {
  CountPendingRequestsHandler();
  document.addEventListener('click', handleClickOutsideMenu);
  document.addEventListener('click', handleClickOutsideTooltip);
});

onBeforeUnmount(() => {
  document.removeEventListener('click', handleClickOutsideMenu);
  document.removeEventListener('click', handleClickOutsideTooltip);
});

const logout = () => {
  // Implementa la lógica de cierre de sesión aquí
};

</script>

<template>
  <nav class="nav">
    <div class="flex flex-row justify-center items-center"> 
      <img src="@/assets/img/DI_IMG.png" alt="Logo" width="90">
      <h1 class="text-sm font-bold pl-4 font-mono w-52">Departamento de Informática</h1>
    </div>
 
    <div class="flex h-full justify-center items-center gap-10"> 
      <div class="relative inline-block" ref="tooltipRef">
        <Icon
          icon="ci:notification"
          class="text-3xl cursor-pointer"
          @click="toggleTooltip"
        />
        <span
          v-if="count_pending_requests !== 0"
          class="absolute flex ml-4 mt-[-33px] items-center justify-center text-center align-middle w-5 h-5 text-xs font-bold text-white bg-red-500 rounded-full"
        >
          {{ count_pending_requests }}
        </span>
    
        <!-- Tooltip -->
        <div
          v-if="tooltipVisible && count_pending_requests !== 0"
          class="absolute left-1/2 transform -translate-x-1/2 mt-3  p-3 text-sm text-white bg-[#1e1e1e] rounded border shadow-2xl text-center"
        >
          Tiene {{ count_pending_requests }} solicitudes sin revisar.
        </div>
      </div>

      <ColorMode />

      <div class="relative" ref="dropdownRef">
        <button @click="toggleMenu" class="user-spec">
          {{ auth_store.username }}
          <Icon icon="teenyicons:down-small-outline" class="icon"/>
        </button>
        <ul v-if="isOpen" class="dropdown-menu">
          <li @click="logout">Cerrar sesión</li>
        </ul>
      </div>
    </div>
  </nav>
</template>

<style scoped lang="postcss">
.nav {
  @apply flex rounded w-full h-24 items-center m-auto border-b border-border mb-5 px-48 justify-between;
}

.user-spec {
  @apply flex items-center bg-input w-auto h-1/2 border border-border rounded-full px-4 py-3 uppercase font-bold hover:border-primary cursor-pointer;
}

.icon {
  @apply text-2xl scale-x-125 pl-1;
}

.dropdown-menu {
  @apply absolute right-0 mt-2 w-48 bg-[#1e1e1e] border border-border rounded-lg shadow-lg z-50;
}

.dropdown-menu li {
  @apply p-3 hover:bg-primary cursor-pointer rounded-lg font-medium;
}
</style>
