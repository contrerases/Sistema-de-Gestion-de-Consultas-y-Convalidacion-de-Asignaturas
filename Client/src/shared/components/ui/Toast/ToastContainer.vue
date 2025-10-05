<script setup lang="ts">
import { ref, onUnmounted } from 'vue';
import Toast, { type Toast as ToastType } from './Toast.vue';

/**
 * Posición del contenedor de toasts
 */
export type ToastPosition = 
  | 'top-left'
  | 'top-center'
  | 'top-right'
  | 'bottom-left'
  | 'bottom-center'
  | 'bottom-right';

/**
 * Props del contenedor de toasts
 */
export interface ToastContainerProps {
  position?: ToastPosition;
  maxToasts?: number;
}

const props = withDefaults(defineProps<ToastContainerProps>(), {
  position: 'top-right',
  maxToasts: 5,
});

const toasts = ref<ToastType[]>([]);
const timers = new Map<string, NodeJS.Timeout>();

const positionClasses: Record<ToastPosition, string> = {
  'top-left': 'top-4 left-4',
  'top-center': 'top-4 left-1/2 -translate-x-1/2',
  'top-right': 'top-4 right-4',
  'bottom-left': 'bottom-4 left-4',
  'bottom-center': 'bottom-4 left-1/2 -translate-x-1/2',
  'bottom-right': 'bottom-4 right-4',
};

const addToast = (toast: Omit<ToastType, 'id'>): void => {
  const id = `toast-${Date.now()}-${Math.random()}`;
  const newToast: ToastType = {
    ...toast,
    id,
    duration: toast.duration ?? 5000,
  };

  toasts.value.push(newToast);

  // Limitar el número de toasts
  if (toasts.value.length > props.maxToasts) {
    const removed = toasts.value.shift();
    if (removed) {
      const timer = timers.get(removed.id);
      if (timer) {
        clearTimeout(timer);
        timers.delete(removed.id);
      }
    }
  }

  // Auto-cerrar después de la duración especificada
  if (newToast.duration && newToast.duration > 0) {
    const timer = setTimeout(() => {
      removeToast(id);
    }, newToast.duration);
    timers.set(id, timer);
  }
};

const removeToast = (id: string): void => {
  const index = toasts.value.findIndex((t) => t.id === id);
  if (index !== -1) {
    toasts.value.splice(index, 1);
    const timer = timers.get(id);
    if (timer) {
      clearTimeout(timer);
      timers.delete(id);
    }
  }
};

const clearAll = (): void => {
  toasts.value = [];
  timers.forEach((timer) => clearTimeout(timer));
  timers.clear();
};

// Exponer métodos para uso externo
defineExpose({
  addToast,
  removeToast,
  clearAll,
});

onUnmounted(() => {
  timers.forEach((timer) => clearTimeout(timer));
  timers.clear();
});
</script>

<template>
  <div :class="['toast-container', positionClasses[position]]">
    <TransitionGroup name="toast-list">
      <Toast
        v-for="toast in toasts"
        :key="toast.id"
        :toast="toast"
        @close="removeToast"
      />
    </TransitionGroup>
  </div>
</template>

<style scoped>
.toast-container {
  @apply fixed z-50 flex flex-col gap-2;
  pointer-events: none;
}

.toast-container > * {
  pointer-events: auto;
}

/* Animaciones de TransitionGroup */
.toast-list-enter-active,
.toast-list-leave-active {
  transition: all 0.3s ease;
}

.toast-list-enter-from {
  opacity: 0;
  transform: translateX(100%);
}

.toast-list-leave-to {
  opacity: 0;
  transform: translateX(100%);
}

.toast-list-move {
  transition: transform 0.3s ease;
}
</style>
