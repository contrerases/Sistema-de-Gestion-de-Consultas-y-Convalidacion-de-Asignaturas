<template>
  <button class="btn" :class="typeClass" :disabled="disabled" @click="onClick">
    <span v-if="$slots.left" class="btn-left">
      <slot name="left" />
    </span>
    <span>
      <slot />
    </span>
    <span v-if="$slots.right" class="btn-right">
      <slot name="right" />
    </span>
  </button>
</template>

<script setup lang="ts">
import { computed } from 'vue';

const props = defineProps({
  type: {
    type: String,
    default: 'default',
    validator: (v: string) => ['default', 'danger', 'outlined', 'disabled'].includes(v)
  },
  disabled: {
    type: Boolean,
    default: false
  }
});
const emit = defineEmits(['click']);

const typeClass = computed(() => {
  switch (props.type) {
    case 'danger':
      return 'bg-destructive text-primary-foreground border border-destructive';
    case 'outlined':
      return 'bg-transparent text-primary border border-primary';
    case 'disabled':
      return 'bg-muted text-muted-foreground border border-border opacity-50 cursor-not-allowed';
    default:
      return 'bg-primary text-primary-foreground border border-primary';
  }
});

function onClick(e: MouseEvent) {
  if (!props.disabled && props.type !== 'disabled') emit('click', e);
}
</script>

<style scoped>
.btn {
  @apply rounded-lg px-4 py-2 transition-opacity duration-200 hover:opacity-80;
}

.btn-left,
.btn-right {
  @apply inline-flex items-center;
}
</style>
