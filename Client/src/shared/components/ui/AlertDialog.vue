<script setup lang="ts">
import { watch, onMounted, onUnmounted, useSlots } from 'vue';
import Button from './Button.vue';

/**
 * Props del componente AlertDialog
 */
export interface AlertDialogProps {
  open?: boolean;
  title?: string;
  description?: string;
  confirmText?: string;
  cancelText?: string;
  variant?: 'default' | 'destructive';
}

/**
 * Eventos emitidos por el componente AlertDialog
 */
export interface AlertDialogEmits {
  'update:open': [value: boolean];
  confirm: [];
  cancel: [];
}

const props = withDefaults(defineProps<AlertDialogProps>(), {
  open: false,
  title: '',
  description: '',
  confirmText: 'Confirmar',
  cancelText: 'Cancelar',
  variant: 'default',
});

const emit = defineEmits<AlertDialogEmits>();
const slots = useSlots();

const closeDialog = (): void => {
  emit('update:open', false);
};

const handleConfirm = (): void => {
  emit('confirm');
  closeDialog();
};

const handleCancel = (): void => {
  emit('cancel');
  closeDialog();
};

const handleEscape = (event: KeyboardEvent): void => {
  if (event.key === 'Escape' && props.open) {
    handleCancel();
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
    <Transition name="alert-dialog-fade">
      <div v-if="open" class="alert-dialog-overlay" @click="handleCancel">
        <Transition name="alert-dialog-slide">
          <div v-if="open" class="alert-dialog-container" @click.stop>
            <!-- Icon -->
            <div class="alert-dialog-icon">
              <div
                :class="[
                  'alert-dialog-icon-wrapper',
                  variant === 'destructive' ? 'alert-dialog-icon-destructive' : 'alert-dialog-icon-default',
                ]"
              >
                <svg
                  v-if="variant === 'destructive'"
                  xmlns="http://www.w3.org/2000/svg"
                  class="w-6 h-6"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke="currentColor"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"
                  />
                </svg>
                <svg
                  v-else
                  xmlns="http://www.w3.org/2000/svg"
                  class="w-6 h-6"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke="currentColor"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"
                  />
                </svg>
              </div>
            </div>

            <!-- Content -->
            <div class="alert-dialog-content">
              <h2 v-if="title || $slots.title" class="alert-dialog-title">
                <slot name="title">{{ title }}</slot>
              </h2>

              <p v-if="description || $slots.description" class="alert-dialog-description">
                <slot name="description">{{ description }}</slot>
              </p>

              <slot />
            </div>

            <!-- Actions -->
            <div class="alert-dialog-actions">
              <Button variant="cancel" @click="handleCancel">{{ cancelText }}</Button>
              <Button :variant="variant === 'destructive' ? 'destructive' : 'default'" @click="handleConfirm">
                {{ confirmText }}
              </Button>
            </div>
          </div>
        </Transition>
      </div>
    </Transition>
  </Teleport>
</template>

<style scoped>
.alert-dialog-overlay {
  @apply fixed inset-0 z-50 flex items-center justify-center backdrop-blur-md;
  background-color: rgba(0, 0, 0, 0.7);
}

.alert-dialog-container {
  @apply relative bg-card text-card-foreground rounded-xl shadow-2xl max-w-md w-full mx-4 p-6;
  background-color: var(--card);
}

.alert-dialog-icon {
  @apply flex justify-center mb-4;
}

.alert-dialog-icon-wrapper {
  @apply w-12 h-12 rounded-full flex items-center justify-center;
}

.alert-dialog-icon-default {
  @apply bg-primary bg-opacity-10 text-primary;
}

.alert-dialog-icon-destructive {
  @apply bg-destructive bg-opacity-10 text-destructive;
}

.alert-dialog-content {
  @apply text-center mb-6;
}

.alert-dialog-title {
  @apply text-xl font-bold mb-2;
}

.alert-dialog-description {
  @apply text-sm text-muted-foreground;
}

.alert-dialog-actions {
  @apply flex gap-3 justify-center;
}

.alert-dialog-fade-enter-active,
.alert-dialog-fade-leave-active {
  transition: opacity 0.2s ease;
}

.alert-dialog-fade-enter-from,
.alert-dialog-fade-leave-to {
  opacity: 0;
}

.alert-dialog-slide-enter-active,
.alert-dialog-slide-leave-active {
  transition: all 0.3s ease;
}

.alert-dialog-slide-enter-from {
  opacity: 0;
  transform: scale(0.95) translateY(-20px);
}

.alert-dialog-slide-leave-to {
  opacity: 0;
  transform: scale(0.95);
}
</style>
