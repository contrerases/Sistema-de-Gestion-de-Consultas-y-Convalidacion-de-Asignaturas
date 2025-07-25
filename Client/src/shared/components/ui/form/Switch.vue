<template>
  <button
    type="button"
    :aria-pressed="modelValue"
    @click="$emit('update:modelValue', !modelValue)"
    :class="[
      'relative inline-flex h-6 w-11 items-center rounded-full transition',
      modelValue ? 'bg-primary' : 'bg-muted'
    ]"
  >
    <span
      :class="[
        'inline-block h-4 w-4 transform rounded-full bg-background shadow transition',
        modelValue ? 'translate-x-6' : 'translate-x-1'
      ]"
    />
  </button>
</template>

<script setup lang="ts">
import { defineProps } from 'vue'
const props = defineProps<{ modelValue: boolean }>()
</script> 