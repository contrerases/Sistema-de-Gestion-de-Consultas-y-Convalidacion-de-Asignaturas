<script setup lang="ts">
import { computed } from 'vue';

/**
 * Variantes del Toast
 */
export type ToastVariant = 'default' | 'success' | 'warning' | 'destructive' | 'info';

/**
 * Interfaz para un toast
 */
export interface Toast {
  id: string;
  title?: string;
  description?: string;
  variant?: ToastVariant;
  duration?: number;
}

/**
 * Props del componente Toast
 */
export interface ToastProps {
  toast: Toast;
}

/**
 * Eventos emitidos por el componente Toast
 */
export interface ToastEmits {
  close: [id: string];
}

const props = defineProps<ToastProps>();
const emit = defineEmits<ToastEmits>();

const variantClasses = computed(() => {
  const variants: Record<ToastVariant, string> = {
    default: 'toast-default',
    success: 'toast-success',
    warning: 'toast-warning',
    destructive: 'toast-destructive',
    info: 'toast-info',
  };
  return variants[props.toast.variant || 'default'];
});

const variantIcon = computed(() => {
  const variant = props.toast.variant || 'default';
  const icons: Record<ToastVariant, string> = {
    default: 'M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z',
    success: 'M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z',
    warning: 'M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z',
    destructive: 'M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z',
    info: 'M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z',
  };
  return icons[variant];
});

const handleClose = (): void => {
  emit('close', props.toast.id);
};
</script>

<template>
  <div :class="['toast', variantClasses]">
    <div class="toast-icon">
      <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" :d="variantIcon" />
      </svg>
    </div>

    <div class="toast-content">
      <p v-if="toast.title" class="toast-title">{{ toast.title }}</p>
      <p v-if="toast.description" class="toast-description">{{ toast.description }}</p>
    </div>

    <button type="button" class="toast-close" @click="handleClose" aria-label="Cerrar">
      <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
      </svg>
    </button>
  </div>
</template>

<style scoped>
.toast {
  @apply flex items-start gap-3 p-4 rounded-lg border shadow-lg;
  @apply min-w-[300px] max-w-md;
  animation: toast-slide-in 0.3s ease-out;
}

.toast-icon {
  @apply flex-shrink-0;
}

.toast-content {
  @apply flex-1;
}

.toast-title {
  @apply text-sm font-semibold mb-1;
}

.toast-description {
  @apply text-sm;
}

.toast-close {
  @apply flex-shrink-0 p-1 rounded hover:bg-black hover:opacity-10 transition-colors;
}

.toast-default {
  @apply bg-card text-card-foreground border-border;
}

.toast-success {
  @apply bg-success text-success-foreground border-success;
  background-color: color-mix(in srgb, var(--success) 10%, var(--card));
}

.toast-warning {
  @apply bg-yellow-500 bg-opacity-10 text-yellow-700 dark:text-yellow-400 border-yellow-500;
}

.toast-destructive {
  @apply bg-destructive text-destructive-foreground border-destructive;
  background-color: color-mix(in srgb, var(--destructive) 10%, var(--card));
}

.toast-info {
  @apply bg-blue-500 bg-opacity-10 text-blue-700 dark:text-blue-400 border-blue-500;
}

@keyframes toast-slide-in {
  from {
    transform: translateX(100%);
    opacity: 0;
  }
  to {
    transform: translateX(0);
    opacity: 1;
  }
}
</style>
