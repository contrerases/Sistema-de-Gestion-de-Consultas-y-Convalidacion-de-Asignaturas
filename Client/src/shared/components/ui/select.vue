<script setup lang="ts">
import { defineProps, defineEmits } from 'vue'
const props = defineProps<{ modelValue: string | number; options: { label: string; value: string | number }[]; disabled?: boolean }>()
const emit = defineEmits(['update:modelValue'])
</script>
<template>
  <select
    :value="props.modelValue"
    @change="emit('update:modelValue', $event.target.value)"
    :disabled="props.disabled"
    class="border rounded px-3 py-2 w-full bg-white dark:bg-gray-800 text-gray-900 dark:text-gray-100 focus:outline-none focus:ring-2 focus:ring-primary"
  >
    <option v-for="option in props.options" :key="option.value" :value="option.value">
      {{ option.label }}
    </option>
  </select>
</template> 