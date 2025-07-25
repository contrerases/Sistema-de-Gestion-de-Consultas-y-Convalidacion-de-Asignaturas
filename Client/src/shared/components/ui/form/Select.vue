<template>
  <div>
    <label v-if="label" :for="id" class="block mb-1 text-sm font-medium text-foreground">{{ label }}</label>
    <select
      :id="id"
      v-model="modelValue"
      :class="[
        'w-full px-3 py-2 border rounded focus:outline-none focus:ring',
        error ? 'border-destructive' : 'border-border',
        'bg-background text-foreground'
      ]"
      v-bind="attrs"
    >
      <option v-for="option in options" :key="option.value" :value="option.value">
        {{ option.label }}
      </option>
    </select>
    <p v-if="error" class="mt-1 text-xs text-destructive">{{ error }}</p>
  </div>
</template>

<script setup lang="ts">
import { defineProps, defineEmits, useAttrs } from 'vue'

const props = defineProps<{
  modelValue: string | number
  label?: string
  id?: string
  options: { label: string; value: string | number }[]
  error?: string
}>()
const emit = defineEmits(['update:modelValue'])
const attrs = useAttrs()
</script> 