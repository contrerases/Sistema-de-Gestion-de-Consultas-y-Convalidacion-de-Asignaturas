<script setup lang="ts">
import ColorMode from '@/components/ColorMode.vue';
import { Icon } from "@iconify/vue";
import { ref, onMounted, onBeforeUnmount } from 'vue';
import { useAuthStore } from '@/stores/auth_store';

const auth_store = useAuthStore();
const isOpen = ref(false);
const dropdownRef = ref<HTMLElement | null>(null);

const toggleMenu = () => {
  isOpen.value = !isOpen.value;
};

const closeMenu = () => {
  isOpen.value = false;
};

const handleClickOutside = (event: MouseEvent) => {
  if (dropdownRef.value && !dropdownRef.value.contains(event.target as Node)) {
    closeMenu();
  }
};

onMounted(() => {
  document.addEventListener('click', handleClickOutside);
});

onBeforeUnmount(() => {
  document.removeEventListener('click', handleClickOutside);
});

const logout = () => {
  // Lógica para cerrar sesión
};
</script>

<template>
  <nav class="nav">
    <div class="flex flex-row justify-center items-center"> 
      <img src="@/assets/img/DI_IMG.png" alt="Logo" width="90">
      <h1 class="text-sm font-bold pl-4 font-mono w-52">Departamento de Informática</h1>
    </div>
 
    <div class="flex h-full justify-center items-center gap-10"> 
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
