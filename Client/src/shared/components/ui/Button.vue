<script setup lang="ts">
import { computed } from 'vue';

type Variant = 'default' | 'destructive' | 'outlined' | 'ghost' | 'cancel';

interface Props {
  variant?: Variant;
  disabled?: boolean;
}

const props = withDefaults(defineProps<Props>(), {
  variant: 'default',
  disabled: false,
});

const emit = defineEmits<{
  click: [event: MouseEvent];
}>();

const variantClasses = computed(() => {
  const variants: Record<Variant, string> = {
    default: 'btn-default',
    destructive: 'btn-destructive',
    outlined: 'btn-outlined',
    ghost: 'btn-ghost',
    cancel: 'btn-cancel',
  };
  return variants[props.variant];
});

const handleClick = (event: MouseEvent) => {
  if (!props.disabled) {
    emit('click', event);
  }
};
</script>

<template>
  <button :class="['btn', variantClasses]" :disabled="disabled" @click="handleClick">
    <span v-if="$slots.left" class="btn-icon">
      <slot name="left" />
    </span>
    <slot />
    <span v-if="$slots.right" class="btn-icon">
      <slot name="right" />
    </span>
  </button>
</template>

<style scoped>
.btn {
  @apply inline-flex shadow-lg items-center justify-center gap-2 rounded-lg px-4 py-2;
  @apply font-medium transition-all duration-200;
  @apply focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary;
  @apply disabled:opacity-50 disabled:cursor-not-allowed disabled:pointer-events-none;
}

.btn-icon {
  @apply inline-flex items-center;
}

.btn-default {
  @apply bg-primary text-primary-foreground border border-primary hover:opacity-90;
}

.btn-destructive {
  @apply bg-destructive text-destructive-foreground border border-destructive hover:opacity-90;
}

.btn-cancel {
  @apply bg-gray-200 text-gray-800 border border-gray-300 hover:bg-gray-300 hover:opacity-90;
}

.btn-outlined {
  @apply bg-transparent text-primary border border-primary hover:bg-primary hover:opacity-90;
}

.btn-ghost {
  @apply bg-transparent text-foreground border border-transparent hover:bg-muted;
}
</style>
