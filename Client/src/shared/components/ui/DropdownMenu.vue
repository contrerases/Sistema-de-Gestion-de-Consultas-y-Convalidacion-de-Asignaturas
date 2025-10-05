<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue';

/**
 * Interfaz para un item del menú
 */
export interface DropdownMenuItem {
  label: string;
  value: string;
  icon?: string;
  disabled?: boolean;
  separator?: boolean;
}

/**
 * Props del componente DropdownMenu
 */
export interface DropdownMenuProps {
  items: DropdownMenuItem[];
  align?: 'left' | 'right';
}

/**
 * Eventos emitidos por el componente DropdownMenu
 */
export interface DropdownMenuEmits {
  select: [item: DropdownMenuItem];
}

const props = withDefaults(defineProps<DropdownMenuProps>(), {
  items: () => [],
  align: 'left',
});

const emit = defineEmits<DropdownMenuEmits>();

const isOpen = ref(false);
const dropdownRef = ref<HTMLElement | null>(null);

const toggleMenu = (): void => {
  isOpen.value = !isOpen.value;
};

const handleItemClick = (item: DropdownMenuItem): void => {
  if (!item.disabled && !item.separator) {
    emit('select', item);
    isOpen.value = false;
  }
};

const handleClickOutside = (event: MouseEvent): void => {
  if (dropdownRef.value && !dropdownRef.value.contains(event.target as Node)) {
    isOpen.value = false;
  }
};

onMounted(() => {
  document.addEventListener('click', handleClickOutside);
});

onUnmounted(() => {
  document.removeEventListener('click', handleClickOutside);
});
</script>

<template>
  <div class="dropdown-menu-wrapper" ref="dropdownRef">
    <div class="dropdown-menu-trigger" @click="toggleMenu">
      <slot name="trigger">
        <button type="button" class="dropdown-menu-button">
          <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 5v.01M12 12v.01M12 19v.01M12 6a1 1 0 110-2 1 1 0 010 2zm0 7a1 1 0 110-2 1 1 0 010 2zm0 7a1 1 0 110-2 1 1 0 010 2z" />
          </svg>
        </button>
      </slot>
    </div>

    <Transition name="dropdown-menu-fade">
      <div
        v-if="isOpen"
        :class="['dropdown-menu-content', `dropdown-menu-align-${align}`]"
      >
        <template v-for="(item, index) in items" :key="index">
          <div v-if="item.separator" class="dropdown-menu-separator"></div>
          <button
            v-else
            type="button"
            :class="[
              'dropdown-menu-item',
              { 'dropdown-menu-item-disabled': item.disabled },
            ]"
            @click="handleItemClick(item)"
          >
            <span v-if="item.icon" class="dropdown-menu-item-icon" v-html="item.icon"></span>
            <span class="dropdown-menu-item-label">{{ item.label }}</span>
          </button>
        </template>
      </div>
    </Transition>
  </div>
</template>

<style scoped>
.dropdown-menu-wrapper {
  @apply relative inline-block;
}

.dropdown-menu-trigger {
  @apply cursor-pointer;
}

.dropdown-menu-button {
  @apply p-2 rounded-lg hover:bg-muted transition-colors;
}

.dropdown-menu-content {
  @apply absolute z-50 mt-2 min-w-[200px] bg-card border border-border rounded-lg shadow-lg overflow-hidden;
  background-color: var(--card);
}

.dropdown-menu-align-left {
  @apply left-0;
}

.dropdown-menu-align-right {
  @apply right-0;
}

.dropdown-menu-item {
  @apply w-full flex items-center gap-3 px-4 py-2.5 text-sm text-foreground;
  @apply hover:bg-muted transition-colors cursor-pointer text-left;
}

.dropdown-menu-item-disabled {
  @apply opacity-50 cursor-not-allowed pointer-events-none;
}

.dropdown-menu-item-icon {
  @apply flex-shrink-0 w-5 h-5;
}

.dropdown-menu-item-label {
  @apply flex-1;
}

.dropdown-menu-separator {
  @apply h-px bg-border my-1;
}

.dropdown-menu-fade-enter-active,
.dropdown-menu-fade-leave-active {
  transition: all 0.2s ease;
}

.dropdown-menu-fade-enter-from,
.dropdown-menu-fade-leave-to {
  opacity: 0;
  transform: translateY(-10px);
}
</style>
