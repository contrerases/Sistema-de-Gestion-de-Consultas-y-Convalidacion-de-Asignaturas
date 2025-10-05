<script setup lang="ts">
import { computed, useSlots } from 'vue';

/**
 * Props del componente Checkbox
 */
export interface CheckboxProps {
  modelValue?: boolean;
  disabled?: boolean;
  required?: boolean;
  label?: string;
}

/**
 * Eventos emitidos por el componente Checkbox
 */
export interface CheckboxEmits {
  'update:modelValue': [value: boolean];
  change: [value: boolean];
}

const props = withDefaults(defineProps<CheckboxProps>(), {
  modelValue: false,
  disabled: false,
  required: false,
  label: '',
});

const emit = defineEmits<CheckboxEmits>();
const slots = useSlots();

const hasLabel = computed(() => !!props.label || !!slots.label);

const handleChange = (event: Event): void => {
  const target = event.target as HTMLInputElement;
  const value = target.checked;
  emit('update:modelValue', value);
  emit('change', value);
};
</script>

<template>
  <div class="checkbox-wrapper">
    <label class="checkbox-container">
      <input
        type="checkbox"
        class="checkbox-input"
        :checked="modelValue"
        :disabled="disabled"
        :required="required"
        @change="handleChange"
      />
      <span class="checkbox-box">
        <svg
          v-if="modelValue"
          xmlns="http://www.w3.org/2000/svg"
          class="checkbox-icon"
          viewBox="0 0 20 20"
          fill="currentColor"
        >
          <path
            fill-rule="evenodd"
            d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z"
            clip-rule="evenodd"
          />
        </svg>
      </span>
      <span v-if="hasLabel" class="checkbox-label">
        <slot name="label">{{ label }}</slot>
      </span>
    </label>
  </div>
</template>

<style scoped>
.checkbox-wrapper {
  @apply inline-flex items-center;
}

.checkbox-container {
  @apply relative flex items-center cursor-pointer select-none;
}

.checkbox-input {
  @apply absolute opacity-0 w-0 h-0;
}

.checkbox-box {
  @apply flex items-center justify-center w-5 h-5 border-2 border-muted-foreground rounded transition-all;
}

.checkbox-input:checked + .checkbox-box {
  @apply bg-primary border-primary;
}

.checkbox-input:disabled + .checkbox-box {
  @apply opacity-50 cursor-not-allowed;
}

.checkbox-input:focus + .checkbox-box {
  @apply ring-2 ring-ring ring-offset-2;
}

.checkbox-icon {
  @apply w-4 h-4 text-primary-foreground;
}

.checkbox-label {
  @apply ml-2 text-sm text-foreground;
}

.checkbox-input:disabled ~ .checkbox-label {
  @apply opacity-50 cursor-not-allowed;
}
</style>
