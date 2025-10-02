<script setup lang="ts">
import { computed } from 'vue';

type Variant = 'default' | 'success' | 'warning' | 'destructive' | 'info';

interface Props {
  variant?: Variant;
  dismissible?: boolean;
}

const props = withDefaults(defineProps<Props>(), {
  variant: 'default',
  dismissible: false,
});

const emit = defineEmits<{
  dismiss: [];
}>();

const variantClasses = computed(() => {
  const variants: Record<Variant, string> = {
    default: 'alert-default',
    success: 'alert-success',
    warning: 'alert-warning',
    destructive: 'alert-destructive',
    info: 'alert-info',
  };
  return variants[props.variant];
});

const handleDismiss = () => {
  emit('dismiss');
};
</script>

<template>
  <div :class="['alert', variantClasses]">
    <!-- Icon -->
    <div v-if="$slots.icon" class="alert-icon">
      <slot name="icon" />
    </div>

    <!-- Content -->
    <div class="alert-content">
      <div v-if="$slots.title" class="alert-title">
        <slot name="title" />
      </div>
      <div v-if="$slots.description" class="alert-description">
        <slot name="description" />
      </div>
      <div v-if="$slots.footer" class="alert-footer">
        <slot name="footer" />
      </div>
    </div>

    <!-- Dismiss button -->
    <button v-if="dismissible" class="alert-dismiss" @click="handleDismiss" aria-label="Cerrar alerta">
      <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
      </svg>
    </button>
  </div>
</template>

<style scoped>
.alert {
  @apply relative flex gap-3 p-4 rounded-lg border;
}

.alert-icon {
  @apply flex-shrink-0;
}

.alert-content {
  @apply flex-1;
}

.alert-title {
  @apply text-base font-semibold mb-1;
}

.alert-description {
  @apply text-sm;
}

.alert-footer {
  @apply flex gap-2 mt-3;
}

.alert-dismiss {
  @apply flex-shrink-0 p-1 rounded-md hover:bg-black/5 dark:hover:bg-white/5 transition-colors;
}

.alert-default {
  @apply bg-card text-card-foreground border-border;
}

.alert-success {
  @apply text-success-foreground;
  background-color: color-mix(in srgb, var(--success) 10%, transparent);
  border-color: color-mix(in srgb, var(--success) 20%, transparent);
}

.alert-warning {
  @apply bg-yellow-500/10 text-yellow-700 dark:text-yellow-400 border-yellow-500/20;
}

.alert-destructive {
  @apply text-destructive-foreground;
  background-color: color-mix(in srgb, var(--destructive) 10%, transparent);
  border-color: color-mix(in srgb, var(--destructive) 20%, transparent);
}

.alert-info {
  @apply bg-blue-500/10 text-blue-700 dark:text-blue-400 border-blue-500/20;
}
</style>
