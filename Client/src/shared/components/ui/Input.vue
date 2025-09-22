<script setup lang="ts">
const props = defineProps({
  modelValue: { type: String, default: '' },
  type: { type: String, default: 'text' },
  placeholder: { type: String, default: '' },
  disabled: { type: Boolean, default: false }
});
const emit = defineEmits(['update:modelValue', 'input']);

function onInput(e: Event) {
  const value = (e.target as HTMLInputElement).value;
  emit('update:modelValue', value);
  emit('input', value);
}
</script>

<template>
  <div class="input-wrapper">
    <label v-if="$slots.label" class="input-label">
      <slot name="label" />
    </label>
    <input class="input" :type="type" :value="modelValue" :placeholder="placeholder" :disabled="disabled"
      @input="onInput" />
  </div>
</template>

<style scoped>
.input-wrapper {
  @apply flex flex-col gap-1 w-full;
}

.input-label {
  @apply text-sm font-medium text-muted-foreground mb-1;
}

.input {
  @apply bg-input text-foreground border border-border rounded px-3 py-2 font-sans transition focus:outline-none focus:ring-2 focus:ring-ring;
}
</style>
