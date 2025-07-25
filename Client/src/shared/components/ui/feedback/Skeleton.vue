<template>
  <div :class="[
    'animate-pulse rounded bg-muted',
    height ? height : 'h-4',
    width ? width : 'w-full'
  ]"></div>
</template>

<script setup lang="ts">
import { defineProps } from 'vue'
const props = defineProps<{ height?: string; width?: string }>()
</script> 