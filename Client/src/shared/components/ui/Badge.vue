<script setup lang="ts">
import { defineProps } from 'vue'
const props = defineProps<{ color?: 'primary' | 'secondary' | 'danger' }>()
</script>
<template>
  <span :class="[
    'inline-block px-2 py-1 rounded text-xs font-semibold',
    props.color === 'primary' ? 'bg-primary text-primary-foreground' : '',
    props.color === 'secondary' ? 'bg-secondary text-secondary-foreground' : '',
    props.color === 'danger' ? 'bg-destructive text-destructive-foreground' : ''
  ]">
    <slot />
  </span>
</template> 