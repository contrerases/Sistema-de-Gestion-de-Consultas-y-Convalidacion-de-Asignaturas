<script setup lang="ts">
import { computed, ref, watch } from 'vue';
import { validateInput } from '@/shared/utils/validator';
import type { InputValidationResult } from '@/shared/utils/validator';

/**
 * Tipos de input soportados
 */
type InputType = 'text' | 'password' | 'email' | 'number' | 'tel' | 'date' | 'time' | 'url';

const props = defineProps({
  // Propiedades base
  modelValue: { type: [String, Number], default: '' },
  type: {
    type: String as () => InputType,
    default: 'text',
    validator: (value: string) => ['text', 'password', 'email', 'number', 'tel', 'date', 'time', 'url'].includes(value)
  },
  placeholder: { type: String, default: '' },

  // Estados del input
  disabled: { type: Boolean, default: false },
  readOnly: { type: Boolean, default: false },
  required: { type: Boolean, default: false },

  // Propiedades para input numérico
  min: { type: [Number, String], default: undefined },
  max: { type: [Number, String], default: undefined },
  step: { type: [Number, String], default: undefined },

  // Propiedades para validación
  pattern: { type: String, default: undefined },

  // Propiedades para fecha/hora
  minDate: { type: String, default: undefined },
  maxDate: { type: String, default: undefined }
});

const emit = defineEmits(['update:modelValue', 'input', 'validationChange']);

// Estado de validación
const isValidated = ref(false);
const validationResult = ref<InputValidationResult>({ isValid: true });
const internalError = computed(() => validationResult.value.errorMessage);
const hasError = computed(() => !validationResult.value.isValid);
const showError = computed(() => isValidated.value && hasError.value);

function onInput(e: Event) {
  const target = e.target as HTMLInputElement;
  let value: string | number = target.value;

  // Conversión específica según el tipo
  if (props.type === 'number' && value !== '') {
    // Convertir a número para inputs numéricos
    value = target.valueAsNumber;
    // Comprobar si es NaN y convertir a string vacío si es necesario
    if (isNaN(value)) value = '';
  }

  emit('update:modelValue', value);
  emit('input', value);

  // Validar si ya se ha validado previamente (usuario ya interactuó)
  if (isValidated.value) {
    validate();
  }
}

// Validar el input
function validate() {
  // Usar el validador mejorado
  validationResult.value = validateInput(props.modelValue, props.type, {
    required: props.required,
    min: props.min !== undefined ? Number(props.min) : undefined,
    max: props.max !== undefined ? Number(props.max) : undefined,
    pattern: props.pattern,
    minDate: props.minDate,
    maxDate: props.maxDate,
    // Añadir validación de longitud si aplica
    minLength: props.type === 'text' || props.type === 'password' ?
      (props.min !== undefined && typeof props.min === 'number' ? props.min : undefined) : undefined,
    maxLength: props.type === 'text' || props.type === 'password' ?
      (props.max !== undefined && typeof props.max === 'number' ? props.max : undefined) : undefined
  });

  // Emitir evento con el resultado de la validación
  emit('validationChange', validationResult.value);
  return validationResult.value.isValid;
}

// Validar al perder el foco
function onBlur() {
  isValidated.value = true;
  validate();
}

// Observar cambios en las propiedades que afectan la validación
watch(
  () => [props.modelValue, props.required, props.min, props.max, props.pattern, props.minDate, props.maxDate],
  () => {
    if (isValidated.value) {
      validate();
    }
  },
  { deep: true }
);



// Computar atributos adicionales según el tipo y la validación
const inputAttrs = computed(() => {
  const attrs: Record<string, string | number | boolean> = {};

  // Atributos para validación general
  if (props.required) {
    attrs.required = true;
    // Añadir mensaje personalizado para validación nativa del navegador
    attrs['data-error-required'] = 'Este campo es obligatorio';
  }

  // Atributos específicos por tipo
  switch (props.type) {
    case 'number':
      if (props.min !== undefined) {
        attrs.min = props.min;
        attrs['data-error-min'] = `El valor mínimo es ${props.min}`;
      }
      if (props.max !== undefined) {
        attrs.max = props.max;
        attrs['data-error-max'] = `El valor máximo es ${props.max}`;
      }
      if (props.step !== undefined) attrs.step = props.step;
      break;

    case 'date':
    case 'time':
      if (props.minDate) {
        attrs.min = props.minDate;
        attrs['data-error-min-date'] = 'La fecha es anterior a la fecha mínima permitida';
      }
      if (props.maxDate) {
        attrs.max = props.maxDate;
        attrs['data-error-max-date'] = 'La fecha es posterior a la fecha máxima permitida';
      }
      break;

    case 'email':
      // Usar el mismo patrón para validación nativa y personalizada
      attrs.pattern = props.pattern ?? '[a-zA-Z0-9._%+\\-]+@[a-zA-Z0-9.\\-]+\\.[a-zA-Z]{2,}';
      attrs['data-error-email'] = 'Ingresa un correo electrónico válido';
      break;

    case 'url':
      attrs.pattern = props.pattern ?? 'https?://.*';
      attrs['data-error-url'] = 'Ingresa una URL válida';
      break;

    case 'text':
    case 'password':
      // Aplicar validaciones de longitud si corresponde
      if (props.min !== undefined && typeof props.min === 'number') {
        attrs.minlength = props.min;
        attrs['data-error-minlength'] = `Debe tener al menos ${props.min} caracteres`;
      }
      if (props.max !== undefined && typeof props.max === 'number') {
        attrs.maxlength = props.max;
        attrs['data-error-maxlength'] = `No debe exceder ${props.max} caracteres`;
      }
      if (props.pattern) {
        attrs.pattern = props.pattern;
        attrs['data-error-pattern'] = 'El formato ingresado no es válido';
      }
      break;
  }

  // Añadir atributo para mensajes de validación personalizados
  if (hasError.value && internalError.value) {
    attrs['aria-errormessage'] = internalError.value;
  }

  return attrs;
});
</script>

<template>
  <div class="input-wrapper">
    <!-- Label del input -->
    <label v-if="$slots.label" class="input-label">
      <slot name="label" />
    </label>

    <!-- Campo de entrada -->
    <input class="input" :type="type" :value="modelValue" :placeholder="placeholder" :disabled="disabled"
      :readonly="readOnly" v-bind="inputAttrs" @input="onInput" @blur="onBlur" :aria-invalid="!validationResult.isValid"
      :aria-errormessage="internalError" />

    <!-- Texto de ayuda -->
    <div v-if="$slots.help" class="input-help">
      <slot name="help" />
    </div>

    <!-- Mensaje de error: solo validación interna -->
    <div v-if="showError" class="input-error">
      {{ internalError }}
    </div>
  </div>
</template>

<style scoped>
/* Clases básicas con utilidades de Tailwind */
.input-wrapper {
  @apply flex flex-col gap-1 w-full;
}

.input-label {
  @apply text-sm font-medium text-foreground mb-1;
}

.input {
  @apply text-sm text-foreground shadow-sm border border-muted-foreground rounded-lg px-3 py-2 font-sans transition focus:outline-none focus:ring-2 focus:ring-ring focus:border-ring placeholder:text-muted-foreground;
}

/* Usar selectores de atributo para los estados */
.input[aria-invalid="true"] {
  @apply border-destructive focus:border-destructive focus:ring-destructive;
}

.input[readonly] {
  @apply bg-muted border-muted-foreground cursor-default opacity-90;
}

.input[disabled] {
  @apply bg-muted border-muted cursor-not-allowed opacity-50;
}

/* Estilos específicos para cada tipo usando selectores de atributo */
.input[type="date"],
.input[type="time"] {
  @apply pr-1 cursor-pointer;
}

/* Quitar flechas de incremento/decremento para inputs numéricos */
.input[type="number"]::-webkit-outer-spin-button,
.input[type="number"]::-webkit-inner-spin-button {
  -webkit-appearance: none;
  margin: 0;
}

/* Para Firefox */
.input[type="number"] {
  @apply appearance-none;
  -moz-appearance: textfield;
  appearance: textfield;
}

.input[type="password"],
.input[type="email"],
.input[type="url"] {
  @apply font-mono;
}

.input-error {
  @apply text-xs text-destructive mt-1;
}

.input-help {
  @apply text-xs text-muted-foreground mt-1;
}
</style>
