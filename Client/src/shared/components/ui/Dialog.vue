<script setup lang="ts">
import { watch, onMounted, onUnmounted, useSlots, computed } from 'vue';

/**
 * Props del componente Dialog
 */
export interface DialogProps {
  open?: boolean;
  title?: string;
}

/**
 * Eventos emitidos por el componente Dialog
 */
export interface DialogEmits {
  'update:open': [value: boolean];
  close: [];
}

const props = withDefaults(defineProps<DialogProps>(), {
  open: false,
  title: '',
});

const emit = defineEmits<DialogEmits>();
const slots = useSlots();

const hasHeader = computed(() => !!props.title || !!slots.header);
const hasFooter = computed(() => !!slots.footer);

const closeDialog = (): void => {
  emit('update:open', false);
  emit('close');
};

const handleEscape = (event: KeyboardEvent): void => {
  if (event.key === 'Escape' && props.open) {
    closeDialog();
  }
};

watch(() => props.open, (isOpen: boolean) => {
  if (isOpen) {
    document.body.style.overflow = 'hidden';
  } else {
    document.body.style.overflow = '';
  }
});

onMounted(() => {
  document.addEventListener('keydown', handleEscape);
});

onUnmounted(() => {
  document.removeEventListener('keydown', handleEscape);
  document.body.style.overflow = '';
});
</script>

<template>
  <Teleport to="body">
    <Transition name="dialog-fade">
      <div v-if="open" class="dialog-overlay" @click="closeDialog">
        <Transition name="dialog-slide">
          <div v-if="open" class="dialog-container" @click.stop>
            <!-- Header -->
            <div v-if="hasHeader" class="dialog-header">
              <slot name="header">
                <h2 class="dialog-title">{{ title }}</h2>
              </slot>
              <button class="dialog-close" @click="closeDialog" aria-label="Cerrar diálogo">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" fill="none" viewBox="0 0 24 24"
                  stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                </svg>
              </button>
            </div>

            <!-- Content -->
            <div class="dialog-content">
              <slot />
            </div>

            <!-- Footer -->
            <div v-if="hasFooter" class="dialog-footer">
              <slot name="footer" />
            </div>
          </div>
        </Transition>
      </div>
    </Transition>
  </Teleport>
</template>

<style scoped>
.dialog-overlay {
  @apply fixed inset-0 z-50 flex items-center justify-center backdrop-blur-md;
  background-color: var(--overlay);
}

.dialog-container {
  @apply relative bg-card text-card-foreground rounded-xl shadow-2xl max-w-lg w-full mx-4 border border-border;
  background-color: var(--card);
}

.dialog-header {
  @apply flex items-center justify-between p-6 border-b border-border;
}

.dialog-title {
  @apply text-xl font-bold;
}

.dialog-close {
  @apply p-1 rounded-md hover:bg-muted transition-colors;
}

.dialog-content {
  @apply p-6;
}

.dialog-footer {
  @apply flex gap-2 justify-end p-6 border-t border-border;
}

.dialog-fade-enter-active,
.dialog-fade-leave-active {
  transition: opacity 0.2s ease;
}

.dialog-fade-enter-from,
.dialog-fade-leave-to {
  opacity: 0;
}

.dialog-slide-enter-active,
.dialog-slide-leave-active {
  transition: all 0.3s ease;
}

.dialog-slide-enter-from {
  opacity: 0;
  transform: scale(0.95) translateY(-20px);
}

.dialog-slide-leave-to {
  opacity: 0;
  transform: scale(0.95);
}
</style>
