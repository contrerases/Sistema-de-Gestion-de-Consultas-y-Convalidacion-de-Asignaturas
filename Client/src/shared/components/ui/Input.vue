<script setup lang="ts">
import { computed, ref, useSlots } from 'vue';

/**
 * Tipos de input soportados
 */
export type InputType =
  | 'text'
  | 'password'
  | 'email'
  | 'number'
  | 'tel'
  | 'url'
  | 'textarea'
  | 'date'
  | 'time';

/**
 * Props del componente Input
 */
export interface InputProps {
  modelValue?: string | number;
  type?: InputType;
  placeholder?: string;
  disabled?: boolean;
  readonly?: boolean;
  required?: boolean;
  min?: number | string;
  max?: number | string;
  minLength?: number;
  maxLength?: number;
  rows?: number;
  cols?: number;
  pattern?: string;
}

const ERROR_MESSAGES = {
  text: {
    valueMissing: 'Este campo de texto es obligatorio',
    typeMismatch: null,
    tooShort: (min: number) => `Debe tener al menos ${min} caracteres`,
    tooLong: (max: number) => `No debe exceder ${max} caracteres`,
    rangeUnderflow: null,
    rangeOverflow: null,
    patternMismatch: 'El texto no cumple con el formato requerido',
  },
  password: {
    valueMissing: 'La contraseña es obligatoria',
    typeMismatch: null,
    tooShort: (min: number) =>
      `La contraseña debe tener al menos ${min} caracteres`,
    tooLong: (max: number) =>
      `La contraseña no debe exceder ${max} caracteres`,
    rangeUnderflow: null,
    rangeOverflow: null,
    patternMismatch:
      'La contraseña no cumple con los requisitos de seguridad',
  },
  email: {
    valueMissing: 'El correo electrónico es obligatorio',
    typeMismatch:
      'Ingresa un correo electrónico válido (ejemplo: usuario@dominio.com)',
    tooShort: null,
    tooLong: (max: number) => `El correo no debe exceder ${max} caracteres`,
    rangeUnderflow: null,
    rangeOverflow: null,
    patternMismatch: null,
  },
  number: {
    valueMissing: 'Este número es obligatorio',
    typeMismatch: 'Ingresa solo números válidos',
    tooShort: null,
    tooLong: null,
    rangeUnderflow: (min: number | string) => `El valor mínimo es ${min}`,
    rangeOverflow: (max: number | string) => `El valor máximo es ${max}`,
    patternMismatch: null,
  },
  tel: {
    valueMissing: 'El teléfono es obligatorio',
    typeMismatch: 'Ingresa un número de teléfono válido',
    tooShort: (min: number) =>
      `El teléfono debe tener al menos ${min} dígitos`,
    tooLong: (max: number) => `El teléfono no debe exceder ${max} dígitos`,
    rangeUnderflow: null,
    rangeOverflow: null,
    patternMismatch: 'El formato del teléfono no es válido',
  },
  url: {
    valueMissing: 'La URL es obligatoria',
    typeMismatch: 'Ingresa una URL válida (ejemplo: https://ejemplo.com)',
    tooShort: null,
    tooLong: (max: number) => `La URL no debe exceder ${max} caracteres`,
    rangeUnderflow: null,
    rangeOverflow: null,
    patternMismatch: null,
  },
  date: {
    valueMissing: 'La fecha es obligatoria',
    typeMismatch: 'Ingresa una fecha válida',
    tooShort: null,
    tooLong: null,
    rangeUnderflow: (min: string) => `La fecha debe ser posterior a ${min}`,
    rangeOverflow: (max: string) => `La fecha debe ser anterior a ${max}`,
    patternMismatch: null,
  },
  time: {
    valueMissing: 'La hora es obligatoria',
    typeMismatch: 'Ingresa una hora válida (formato HH:MM)',
    tooShort: null,
    tooLong: null,
    rangeUnderflow: (min: string) => `La hora debe ser posterior a ${min}`,
    rangeOverflow: (max: string) => `La hora debe ser anterior a ${max}`,
    patternMismatch: null,
  },
  textarea: {
    valueMissing: 'Este campo es obligatorio',
    typeMismatch: null,
    tooShort: (min: number) => `Debe tener al menos ${min} caracteres`,
    tooLong: (max: number) => `No debe exceder ${max} caracteres`,
    rangeUnderflow: null,
    rangeOverflow: null,
    patternMismatch: null,
  },
} as const;

/**
 * Eventos emitidos por el componente Input
 */
export interface InputEmits {
  'update:modelValue': [value: string | number];
  input: [value: string | number];
}

const props = withDefaults(defineProps<InputProps>(), {
  type: 'text',
  placeholder: '',
  disabled: false,
  readonly: false,
  required: false,
  rows: 3,
  cols: 20,
});

const emit = defineEmits<InputEmits>();
const slots = useSlots();

const isValid = ref<boolean | null>(null);
const validationError = ref('');
const touched = ref(false);

const hasHelp = computed(() => !!slots.help);
const hasLabel = computed(() => !!slots.label);
const hasPrefix = computed(() => !!slots.prefix);
const hasSuffix = computed(() => !!slots.suffix);

const isText = computed(() =>
  ['text', 'textarea', 'password'].includes(props.type)
);
const currentLength = computed(() =>
  props.modelValue ? String(props.modelValue).length : 0
);

// Clases compartidas para input y textarea
const inputClasses = computed(() => ({
  'input-with-prefix': !!slots.prefix,
  'input-with-suffix': !!slots.suffix,
  'input-invalid': touched.value && !isValid.value,
  'input-valid': isValid.value,
}));

const lengthClasses = computed(() => ({
  'text-muted-foreground': isValid.value,
  'text-destructive': !isValid.value,
}));

function onInvalid(e: Event) {
  if (!touched.value) {
    isValid.value = false;
    return;
  }
  e.preventDefault();
  const target = e.target as HTMLInputElement;
  isValid.value = target.checkValidity();
  touched.value = true;
}

function onInput(e: Event) {
  const target = e.target as HTMLInputElement;
  const value: string | number = target.value;
  isValid.value = touched.value ? target.checkValidity() : null;
  emit('update:modelValue', value);
  emit('input', value);
}

function onBlur(e: Event) {
  const target = e.target as HTMLInputElement;
  touched.value = true;
  isValid.value = target.checkValidity();
  validationError.value = target.validationMessage;
}

const errorAttrs = computed(() => {
  const attrs: Record<string, string> = {};
  const messages = ERROR_MESSAGES[props.type];

  if (props.required && messages.valueMissing) {
    attrs['data-error-valuemissing'] = messages.valueMissing;
  }

  if (props.minLength && messages.tooShort) {
    attrs['data-error-tooshort'] = messages.tooShort(props.minLength);
  }

  if (props.maxLength && messages.tooLong) {
    attrs['data-error-toolong'] = messages.tooLong(props.maxLength);
  }

  if (props.min && messages.rangeUnderflow) {
    attrs['data-error-rangeunderflow'] = messages.rangeUnderflow(
      String(props.min)
    );
  }

  if (props.max && messages.rangeOverflow) {
    attrs['data-error-rangeoverflow'] = messages.rangeOverflow(
      String(props.max)
    );
  }

  if (messages.typeMismatch) {
    attrs['data-error-typemismatch'] = messages.typeMismatch;
  }

  if (messages.patternMismatch) {
    attrs['data-error-patternmismatch'] = messages.patternMismatch;
  }

  return attrs;
});
</script>

<template>
  <div class="input-wrapper">
    <!-- Label del input -->
    <label v-if="hasLabel" class="input-label">
      <slot name="label" />
    </label>

    <div class="input-container">
      <div v-if="hasPrefix" class="input-icon input-prefix">
        <slot name="prefix" />
      </div>

      <template v-if="type !== 'textarea'">
        <input class="input" :class="inputClasses" :type="type" :value="modelValue" :placeholder="placeholder"
          :required="required" :disabled="disabled" :readonly="readonly" :min="min" :max="max" :minlength="minLength"
          :maxlength="maxLength" :pattern="pattern" v-bind="errorAttrs" @input="onInput" @invalid="onInvalid"
          @blur="onBlur" />
      </template>
      <template v-else>
        <textarea class="input textarea" :class="inputClasses" :value="modelValue" :placeholder="placeholder"
          :required="required" :disabled="disabled" :readonly="readonly" :minlength="minLength" :maxlength="maxLength"
          :rows="rows" :cols="cols" v-bind="errorAttrs" @input="onInput" @invalid="onInvalid" @blur="onBlur">
        </textarea>
      </template>

      <div v-if="hasSuffix" class="input-icon input-suffix">
        <slot name="suffix" />
      </div>
    </div>

    <div v-if="hasHelp" class="input-help">
      <slot name="help" />
      <div class="length-indicator" :class="lengthClasses" v-if="isText">
        <span>
          {{ currentLength }} <span v-if="maxLength">/ {{ maxLength }}</span>
        </span>
      </div>
    </div>

    <div v-if="!isValid && touched" class="input-invalid-message">
      {{ validationError }}
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

/* Container para input con iconos */
.input-container {
  @apply relative flex items-center;
}

.input {
  @apply text-sm text-foreground shadow-sm border border-muted-foreground rounded-lg px-3 py-2 font-sans transition focus:outline-none focus:ring-2 focus:ring-ring focus:border-ring placeholder:text-muted-foreground w-full;
}

/* Inputs con iconos - ajustar padding */
.input-with-prefix {
  @apply pl-10;
}

.input-with-suffix {
  @apply pr-10;
}

/* Iconos del input */
.input-icon {
  @apply absolute z-10 flex items-center justify-center w-5 h-5 text-muted-foreground pointer-events-none;
}

.input-prefix {
  @apply left-3;
}

.input-suffix {
  @apply right-3;
}

.input[readonly] {
  @apply bg-muted border-muted-foreground cursor-default opacity-90 transition-none;
}

.input[disabled] {
  @apply bg-muted border-muted cursor-not-allowed opacity-50;
}

.input-valid {
  @apply focus:border-success focus:ring-success;
}

.input-invalid {
  @apply border-destructive focus:border-destructive focus:ring-destructive;
}



/* Quitar flechas de incremento/decremento para inputs numéricos */
.input[type='number']::-webkit-outer-spin-button,
.input[type='number']::-webkit-inner-spin-button {
  -webkit-appearance: none;
  margin: 0;
}

/* Para Firefox */
.input[type='number'] {
  @apply appearance-none;
  -moz-appearance: textfield;
  appearance: textfield;
}

.input[type='password'],
.input[type='email'],
.input[type='url'] {
  @apply font-mono;
}

/* Estilo específico para textarea */
.textarea {
  @apply min-h-[60px] leading-normal;
  resize: none;
  /* Siempre vertical como solicitado */
}

.input-invalid-message {
  @apply text-xs text-destructive mt-1;
}

.input-help {
  @apply flex justify-between text-xs text-muted-foreground mt-1;
}

.length-indicator {
  @apply font-mono flex justify-end;
}
</style>
