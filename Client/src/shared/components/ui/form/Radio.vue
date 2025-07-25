<template>
  <label class="inline-flex items-center gap-2 cursor-pointer">
    <input
      type="radio"
      :checked="modelValue === value"
      @change="$emit('update:modelValue', value)"
      class="accent-primary h-4 w-4 rounded-full border border-border focus:ring focus:ring-primary"
      v-bind="attrs"
    />
    <span class="text-foreground"><slot /></span>
  </label>
</template>

<script setup lang="ts">
import { defineProps, useAttrs } from 'vue'
const props = defineProps<{ modelValue: string | number; value: string | number }>()
const attrs = useAttrs()
</script> 