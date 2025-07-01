<script setup lang="ts">
import { computed, defineProps, defineEmits } from 'vue'
const props = defineProps<{
  variant?: 'primary' | 'secondary' | 'danger'
  size?: 'sm' | 'md' | 'lg'
  disabled?: boolean
}>()
const emit = defineEmits(['click'])

const variantClass = computed(() => ({
  primary: 'bg-primary text-primary-foreground hover:bg-primary/90',
  secondary: 'bg-secondary text-secondary-foreground hover:bg-secondary/90',
  danger: 'bg-destructive text-destructive-foreground hover:bg-destructive-hover'
}[props.variant || 'primary']))

const sizeClass = computed(() => ({
  sm: 'text-sm py-1 px-2',
  md: 'text-base py-2 px-4',
  lg: 'text-lg py-3 px-6'
}[props.size || 'md']))

function onClick(event: MouseEvent) {
  if (!props.disabled) emit('click', event)
}
</script> 

<template>
  <button
    :class="[
      'font-semibold rounded-lg transition px-4 py-2',
      variantClass.value,
      sizeClass.value,
      { 'opacity-50 cursor-not-allowed': props.disabled }
    ]"
    :disabled="props.disabled"
    @click="onClick"
  >
    <slot />
  </button>
</template>

