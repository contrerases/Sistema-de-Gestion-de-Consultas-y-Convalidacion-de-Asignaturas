<template>
  <div :class="[
    'rounded px-4 py-3 mb-2',
    type === 'error' ? 'bg-destructive text-destructive-foreground' : '',
    type === 'success' ? 'bg-success text-success-foreground' : '',
    type === 'info' ? 'bg-accent text-accent-foreground' : '',
    type === 'warning' ? 'bg-muted text-muted-foreground' : ''
  ]">
    <slot />
  </div>
</template>

<script setup lang="ts">
import { defineProps } from 'vue'
const props = defineProps<{ type?: 'error' | 'success' | 'info' | 'warning' }>()
</script> 