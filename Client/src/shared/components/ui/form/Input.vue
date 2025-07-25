<template>
  <div>
    <label v-if="label" :for="id" class="block mb-1 text-sm font-medium text-foreground">{{ label }}</label>
    <input
      :id="id"
      :type="type"
      v-bind="attrs"
      v-model="modelValue"
      :class="[
        'w-full px-3 py-2 border rounded focus:outline-none focus:ring',
        error ? 'border-destructive' : 'border-border',
        'bg-background text-foreground'
      ]"
    />
    <p v-if="error" class="mt-1 text-xs text-destructive">{{ error }}</p>
  </div>
</template>

<script setup lang="ts">
import { defineProps, defineEmits, useAttrs } from 'vue'

const props = defineProps<{
  modelValue: string
  label?: string
  id?: string
  type?: string
  error?: string
}>()
const emit = defineEmits(['update:modelValue'])
const attrs = useAttrs()
</script> 