<script setup lang="ts">
import { computed } from 'vue';

/**
 * Variantes del componente Skeleton
 */
export type SkeletonVariant = 'text' | 'circular' | 'rectangular';

/**
 * Props del componente Skeleton
 */
export interface SkeletonProps {
  variant?: SkeletonVariant;
  width?: string;
  height?: string;
  count?: number;
}

const props = withDefaults(defineProps<SkeletonProps>(), {
  variant: 'text',
  width: '100%',
  height: '1rem',
  count: 1,
});

const skeletonClasses = computed(() => {
  const variants: Record<SkeletonVariant, string> = {
    text: 'skeleton-text',
    circular: 'skeleton-circular',
    rectangular: 'skeleton-rectangular',
  };
  return variants[props.variant];
});

const skeletonStyle = computed(() => ({
  width: props.width,
  height: props.height,
}));
</script>

<template>
  <div class="skeleton-container">
    <div
      v-for="index in count"
      :key="index"
      :class="['skeleton', skeletonClasses]"
      :style="skeletonStyle"
    ></div>
  </div>
</template>

<style scoped>
.skeleton-container {
  @apply flex flex-col gap-2;
}

.skeleton {
  @apply bg-muted animate-pulse;
}

.skeleton-text {
  @apply rounded;
}

.skeleton-circular {
  @apply rounded-full;
}

.skeleton-rectangular {
  @apply rounded-lg;
}

@keyframes pulse {
  0%,
  100% {
    opacity: 1;
  }
  50% {
    opacity: 0.5;
  }
}

.animate-pulse {
  animation: pulse 2s cubic-bezier(0.4, 0, 0.6, 1) infinite;
}
</style>
