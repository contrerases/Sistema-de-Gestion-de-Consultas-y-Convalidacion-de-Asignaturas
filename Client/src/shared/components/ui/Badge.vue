<script setup lang="ts">
import { computed } from 'vue';

/**
 * Variantes del componente Badge
 */
export type BadgeVariant = 'default' | 'primary' | 'success' | 'warning' | 'destructive' | 'info' | 'outline';

/**
 * Tamaños del componente Badge
 */
export type BadgeSize = 'sm' | 'md' | 'lg';

/**
 * Props del componente Badge
 */
export interface BadgeProps {
  variant?: BadgeVariant;
  size?: BadgeSize;
}

const props = withDefaults(defineProps<BadgeProps>(), {
  variant: 'default',
  size: 'md',
});

const badgeClasses = computed(() => {
  const variants: Record<BadgeVariant, string> = {
    default: 'badge-default',
    primary: 'badge-primary',
    success: 'badge-success',
    warning: 'badge-warning',
    destructive: 'badge-destructive',
    info: 'badge-info',
    outline: 'badge-outline',
  };

  const sizes: Record<BadgeSize, string> = {
    sm: 'badge-sm',
    md: 'badge-md',
    lg: 'badge-lg',
  };

  return [variants[props.variant], sizes[props.size]];
});
</script>

<template>
  <span :class="['badge', ...badgeClasses]">
    <slot />
  </span>
</template>

<style scoped>
.badge {
  @apply inline-flex items-center justify-center font-medium rounded-full transition-colors;
}

.badge-sm {
  @apply text-xs px-2 py-0.5;
}

.badge-md {
  @apply text-sm px-2.5 py-0.5;
}

.badge-lg {
  @apply text-base px-3 py-1;
}

.badge-default {
  @apply bg-card text-card-foreground border border-border;
}

.badge-primary {
  @apply bg-primary text-primary-foreground;
}

.badge-success {
  @apply bg-success text-success-foreground;
}

.badge-warning {
  @apply bg-yellow-500 text-white;
}

.badge-destructive {
  @apply bg-destructive text-destructive-foreground;
}

.badge-info {
  @apply bg-blue-500 text-white;
}

.badge-outline {
  @apply bg-transparent text-foreground border border-border;
}
</style>
