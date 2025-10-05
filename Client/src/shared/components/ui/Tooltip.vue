<script setup lang="ts">
import { ref, computed } from 'vue';

/**
 * Posiciones del Tooltip
 */
export type TooltipPosition = 'top' | 'bottom' | 'left' | 'right';

/**
 * Props del componente Tooltip
 */
export interface TooltipProps {
  text?: string;
  position?: TooltipPosition;
  disabled?: boolean;
}

const props = withDefaults(defineProps<TooltipProps>(), {
  text: '',
  position: 'top',
  disabled: false,
});

const isVisible = ref(false);

const positionClasses = computed(() => {
  const positions: Record<TooltipPosition, string> = {
    top: 'tooltip-top',
    bottom: 'tooltip-bottom',
    left: 'tooltip-left',
    right: 'tooltip-right',
  };
  return positions[props.position];
});

const showTooltip = (): void => {
  if (!props.disabled) {
    isVisible.value = true;
  }
};

const hideTooltip = (): void => {
  isVisible.value = false;
};
</script>

<template>
  <div class="tooltip-wrapper" @mouseenter="showTooltip" @mouseleave="hideTooltip">
    <slot />
    <Transition name="tooltip-fade">
      <div v-if="isVisible && !disabled" :class="['tooltip', positionClasses]">
        <slot name="content">{{ text }}</slot>
      </div>
    </Transition>
  </div>
</template>

<style scoped>
.tooltip-wrapper {
  @apply relative inline-block;
}

.tooltip {
  @apply absolute z-50 px-2 py-1 text-xs font-medium text-white bg-gray-900 rounded shadow-lg whitespace-nowrap;
  pointer-events: none;
}

.tooltip-top {
  @apply bottom-full left-1/2 -translate-x-1/2 mb-2;
}

.tooltip-bottom {
  @apply top-full left-1/2 -translate-x-1/2 mt-2;
}

.tooltip-left {
  @apply right-full top-1/2 -translate-y-1/2 mr-2;
}

.tooltip-right {
  @apply left-full top-1/2 -translate-y-1/2 ml-2;
}

.tooltip-fade-enter-active,
.tooltip-fade-leave-active {
  transition: opacity 0.2s ease;
}

.tooltip-fade-enter-from,
.tooltip-fade-leave-to {
  opacity: 0;
}
</style>
