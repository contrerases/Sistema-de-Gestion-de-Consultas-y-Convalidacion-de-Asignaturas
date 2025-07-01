<script setup lang="ts">
import { ref } from 'vue'
const isOpen = ref(false)
function toggle() { isOpen.value = !isOpen.value }
</script>
<template>
  <div class="relative inline-block">
    <button @click="toggle" class="px-4 py-2 bg-primary text-primary-foreground rounded">
      <slot name="button">Abrir</slot>
    </button>
    <div v-if="isOpen" class="absolute right-0 mt-2 w-48 bg-white dark:bg-gray-900 rounded shadow-lg z-10">
      <slot />
    </div>
  </div>
</template> 