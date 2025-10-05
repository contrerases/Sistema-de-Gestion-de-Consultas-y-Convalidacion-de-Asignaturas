<script setup lang="ts">
import { computed, ref, onMounted, onUnmounted, useSlots } from 'vue';

/**
 * Interfaz para una opción del Select
 */
export interface SelectOption {
  label: string;
  value: string | number;
  disabled?: boolean;
}

/**
 * Props del componente Select
 */
export interface SelectProps {
  modelValue?: string | number;
  options: SelectOption[];
  placeholder?: string;
  disabled?: boolean;
  searchable?: boolean;
  clearable?: boolean;
  required?: boolean;
}

/**
 * Eventos emitidos por el componente Select
 */
export interface SelectEmits {
  'update:modelValue': [value: string | number];
  change: [value: string | number];
  clear: [];
}

const props = withDefaults(defineProps<SelectProps>(), {
  modelValue: '',
  options: () => [],
  placeholder: 'Seleccionar...',
  disabled: false,
  searchable: false,
  clearable: false,
  required: false,
});

const emit = defineEmits<SelectEmits>();
const slots = useSlots();

const isOpen = ref(false);
const searchQuery = ref('');
const selectRef = ref<HTMLElement | null>(null);

const hasLabel = computed(() => !!slots.label);

const selectedOption = computed(() => {
  return props.options.find(opt => opt.value === props.modelValue);
});

const filteredOptions = computed(() => {
  if (!props.searchable || !searchQuery.value) {
    return props.options;
  }
  return props.options.filter(opt =>
    opt.label.toLowerCase().includes(searchQuery.value.toLowerCase())
  );
});

const toggleDropdown = (): void => {
  if (!props.disabled) {
    isOpen.value = !isOpen.value;
    if (!isOpen.value) {
      searchQuery.value = '';
    }
  }
};

const selectOption = (option: SelectOption): void => {
  if (!option.disabled) {
    emit('update:modelValue', option.value);
    emit('change', option.value);
    isOpen.value = false;
    searchQuery.value = '';
  }
};

const clearSelection = (event: Event): void => {
  event.stopPropagation();
  emit('update:modelValue', '');
  emit('clear');
};

const handleClickOutside = (event: MouseEvent): void => {
  if (selectRef.value && !selectRef.value.contains(event.target as Node)) {
    isOpen.value = false;
    searchQuery.value = '';
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
  <div class="select-wrapper" ref="selectRef">
    <label v-if="hasLabel" class="select-label">
      <slot name="label" />
    </label>

    <div
      :class="['select-trigger', { 'select-open': isOpen, 'select-disabled': disabled }]"
      @click="toggleDropdown"
    >
      <span v-if="selectedOption" class="select-value">{{ selectedOption.label }}</span>
      <span v-else class="select-placeholder">{{ placeholder }}</span>

      <div class="select-icons">
        <button
          v-if="clearable && selectedOption"
          type="button"
          class="select-clear"
          @click="clearSelection"
          aria-label="Limpiar selección"
        >
          <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
          </svg>
        </button>

        <svg
          xmlns="http://www.w3.org/2000/svg"
          :class="['select-arrow', { 'select-arrow-open': isOpen }]"
          fill="none"
          viewBox="0 0 24 24"
          stroke="currentColor"
        >
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
        </svg>
      </div>
    </div>

    <Transition name="select-dropdown">
      <div v-if="isOpen" class="select-dropdown">
        <div v-if="searchable" class="select-search">
          <input
            v-model="searchQuery"
            type="text"
            class="select-search-input"
            placeholder="Buscar..."
            @click.stop
          />
        </div>

        <div class="select-options">
          <div
            v-for="option in filteredOptions"
            :key="option.value"
            :class="[
              'select-option',
              {
                'select-option-selected': option.value === modelValue,
                'select-option-disabled': option.disabled,
              },
            ]"
            @click="selectOption(option)"
          >
            {{ option.label }}
            <svg
              v-if="option.value === modelValue"
              xmlns="http://www.w3.org/2000/svg"
              class="w-4 h-4 ml-auto"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
            >
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
            </svg>
          </div>

          <div v-if="filteredOptions.length === 0" class="select-empty">
            No se encontraron resultados
          </div>
        </div>
      </div>
    </Transition>
  </div>
</template>

<style scoped>
.select-wrapper {
  @apply relative w-full;
}

.select-label {
  @apply block text-sm font-medium text-foreground mb-1;
}

.select-trigger {
  @apply relative flex items-center justify-between w-full px-3 py-2;
  @apply text-sm text-foreground bg-background border border-muted-foreground rounded-lg;
  @apply cursor-pointer transition-all shadow-sm;
  @apply hover:border-ring focus:outline-none focus:ring-2 focus:ring-ring;
}

.select-trigger:hover:not(.select-disabled) {
  @apply border-primary;
}

.select-open {
  @apply border-primary ring-2 ring-ring;
}

.select-disabled {
  @apply opacity-50 cursor-not-allowed;
}

.select-value {
  @apply truncate;
}

.select-placeholder {
  @apply text-muted-foreground;
}

.select-icons {
  @apply flex items-center gap-1 ml-2;
}

.select-clear {
  @apply p-0.5 rounded hover:bg-muted transition-colors;
}

.select-arrow {
  @apply w-4 h-4 text-muted-foreground transition-transform;
}

.select-arrow-open {
  @apply rotate-180;
}

.select-dropdown {
  @apply absolute z-50 w-full mt-1 bg-card border border-border rounded-lg shadow-lg overflow-hidden;
}

.select-search {
  @apply p-2 border-b border-border;
}

.select-search-input {
  @apply w-full px-3 py-1.5 text-sm bg-background border border-muted-foreground rounded;
  @apply focus:outline-none focus:ring-2 focus:ring-ring;
}

.select-options {
  @apply max-h-60 overflow-y-auto;
}

.select-option {
  @apply flex items-center px-3 py-2 text-sm cursor-pointer transition-colors;
  @apply hover:bg-muted;
}

.select-option-selected {
  @apply bg-primary bg-opacity-10 text-primary font-medium;
}

.select-option-disabled {
  @apply opacity-50 cursor-not-allowed;
}

.select-empty {
  @apply px-3 py-2 text-sm text-center text-muted-foreground;
}

.select-dropdown-enter-active,
.select-dropdown-leave-active {
  transition: all 0.2s ease;
}

.select-dropdown-enter-from,
.select-dropdown-leave-to {
  opacity: 0;
  transform: translateY(-10px);
}
</style>
