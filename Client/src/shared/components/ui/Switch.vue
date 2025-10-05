<script setup lang="ts">
import { computed, useSlots } from 'vue';

/**
 * Props del componente Switch
 */
export interface SwitchProps {
  modelValue?: boolean;
  disabled?: boolean;
  label?: string;
}

/**
 * Eventos emitidos por el componente Switch
 */
export interface SwitchEmits {
  'update:modelValue': [value: boolean];
  change: [value: boolean];
}

const props = withDefaults(defineProps<SwitchProps>(), {
  modelValue: false,
  disabled: false,
  label: '',
});

const emit = defineEmits<SwitchEmits>();
const slots = useSlots();

const hasLabel = computed(() => !!props.label || !!slots.label);

const handleChange = (): void => {
  if (!props.disabled) {
    const newValue = !props.modelValue;
    emit('update:modelValue', newValue);
    emit('change', newValue);
  }
};
</script>

<template>
  <div class="switch-wrapper">
    <label class="switch-container">
      <input
        type="checkbox"
        class="switch-input"
        :checked="modelValue"
        :disabled="disabled"
        @change="handleChange"
      />
      <span class="switch-track">
        <span class="switch-thumb"></span>
      </span>
      <span v-if="hasLabel" class="switch-label">
        <slot name="label">{{ label }}</slot>
      </span>
    </label>
  </div>
</template>

<style scoped>
.switch-wrapper {
  @apply inline-flex items-center;
}

.switch-container {
  @apply relative flex items-center cursor-pointer select-none;
}

.switch-input {
  @apply absolute opacity-0 w-0 h-0;
}

.switch-track {
  @apply relative inline-block w-11 h-6 rounded-full bg-muted border border-border transition-colors;
}

.switch-input:checked + .switch-track {
  @apply bg-primary border-primary;
}

.switch-input:disabled + .switch-track {
  @apply opacity-50 cursor-not-allowed;
}

.switch-input:focus + .switch-track {
  @apply ring-2 ring-ring ring-offset-2;
}

.switch-thumb {
  @apply absolute top-0.5 left-0.5 w-5 h-5 rounded-full bg-white transition-transform shadow-sm;
}

.switch-input:checked + .switch-track .switch-thumb {
  @apply translate-x-5;
}

.switch-label {
  @apply ml-3 text-sm text-foreground;
}

.switch-input:disabled ~ .switch-label {
  @apply opacity-50 cursor-not-allowed;
}
</style>
