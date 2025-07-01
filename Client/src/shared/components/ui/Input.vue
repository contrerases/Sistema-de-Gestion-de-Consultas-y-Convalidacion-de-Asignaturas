<script setup lang="ts">
import { defineProps, defineEmits } from 'vue'
const props = defineProps<{ modelValue: string; type?: string; placeholder?: string; disabled?: boolean }>()
const emit = defineEmits(['update:modelValue'])
</script>
<template>
  <input
    :type="props.type || 'text'"
    :placeholder="props.placeholder"
    :disabled="props.disabled"
    :value="props.modelValue"
    @input="emit('update:modelValue', $event.target.value)"
    class="border rounded px-3 py-2 w-full bg-white dark:bg-gray-800 text-gray-900 dark:text-gray-100 focus:outline-none focus:ring-2 focus:ring-primary"
  />
</template> 