<template>
  <button
    :type="type"
    :disabled="loading || disabled"
    :class="[
      'inline-flex items-center justify-center px-4 py-2 rounded font-medium transition',
      loading ? 'opacity-70 cursor-not-allowed' : '',
      variant === 'primary' ? 'bg-primary text-primary-foreground hover:bg-primary/90' : '',
      variant === 'secondary' ? 'bg-secondary text-secondary-foreground hover:bg-secondary/90' : '',
      variant === 'destructive' ? 'bg-destructive text-destructive-foreground hover:bg-destructive-hover' : '',
      'focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2'
    ]"
    v-bind="attrs"
  >
    <Spinner v-if="loading" class="mr-2 h-4 w-4" />
    <slot />
  </button>
</template>

<script setup lang="ts">
import { defineProps, useAttrs } from 'vue'
import Spinner from '@/modules/shared/components/ui/feedback/Spinner.vue'

const props = defineProps<{
  type?: 'button' | 'submit' | 'reset'
  loading?: boolean
  disabled?: boolean
  variant?: 'primary' | 'secondary' | 'destructive'
}>()
const attrs = useAttrs()
</script> 