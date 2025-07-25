<template>
  <label class="inline-flex items-center gap-2 cursor-pointer">
    <input
      type="checkbox"
      :checked="modelValue"
      @change="$emit('update:modelValue', $event.target.checked)"
      class="accent-primary h-4 w-4 rounded border border-border focus:ring focus:ring-primary"
      v-bind="attrs"
    />
    <span class="text-foreground"><slot /></span>
  </label>
</template>

<script setup lang="ts">
import { defineProps, useAttrs } from 'vue'
const props = defineProps<{ modelValue: boolean }>()
const attrs = useAttrs()
</script> 