<script setup lang="ts">
import { computed, ref, watch, nextTick, useSlots } from 'vue';
import Input from './Input.vue';

/**
 * Interfaz para un día del calendario
 */
export interface CalendarDay {
  day: number;
  month: number;
  year: number;
  isCurrentMonth: boolean;
  isToday: boolean;
  isSelected: boolean;
}

/**
 * Props del componente DatePicker
 */
export interface DatePickerProps {
  modelValue?: string;
  placeholder?: string;
  disabled?: boolean;
  readOnly?: boolean;
  required?: boolean;
  minDate?: string;
  maxDate?: string;
  pastDays?: boolean;
  showDate?: boolean;
  showTime?: boolean;
}

/**
 * Eventos emitidos por el componente DatePicker
 */
export interface DatePickerEmits {
  'update:modelValue': [value: string];
}

const props = withDefaults(defineProps<DatePickerProps>(), {
  modelValue: '',
  placeholder: 'Seleccione fecha y hora',
  disabled: false,
  readOnly: false,
  required: false,
  minDate: undefined,
  maxDate: undefined,
  showDate: true,
  showTime: true,
});

const emit = defineEmits<DatePickerEmits>();
const slots = useSlots();

// Referencias para manejo de calendario y selectores
const datePickerRef = ref<HTMLElement | null>(null);
const timePickerRef = ref<HTMLElement | null>(null);
const showDatePicker = ref(false);
const showTimePicker = ref(false);

// Estado interno
const selectedDate = ref(''); // Formato YYYY-MM-DD
const selectedTime = ref(''); // Formato HH:MM
const timeInputHours = ref('');
const timeInputMinutes = ref('');



// Parsear el valor inicial si existe
function parseModelValue(): void {
  if (!props.modelValue) {
    selectedDate.value = '';
    selectedTime.value = '';
    timeInputHours.value = '';
    timeInputMinutes.value = '';
    return;
  }

  try {
    const date = new Date(props.modelValue);
    if (!isNaN(date.getTime())) {
      // Formato YYYY-MM-DD
      selectedDate.value = date.toISOString().split('T')[0];

      // Formato HH:MM
      const hours = date.getHours().toString().padStart(2, '0');
      const minutes = date.getMinutes().toString().padStart(2, '0');
      selectedTime.value = `${hours}:${minutes}`;
      timeInputHours.value = hours;
      timeInputMinutes.value = minutes;
    }
  } catch (e) {
    console.error('Error parsing date:', e);
  }
}

// Inicializar valores
parseModelValue();

// Nota: Función eliminada porque no se usa

// Valores computados para mostrar en inputs
const displayDate = computed(() => {
  if (!selectedDate.value) return '';

  const [year, month, day] = selectedDate.value.split('-');
  const monthNames = [
    'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
    'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'
  ];
  // Formato natural: 9 septiembre, 2025
  return `${parseInt(day)} ${monthNames[parseInt(month) - 1]}, ${year}`;
});

const displayTime = computed(() => {
  if (!selectedTime.value) return '';

  // Aseguramos que siempre tenga el formato HH:MM correcto
  const parts = selectedTime.value.split(':');
  const hours = parts[0] ? parts[0].padStart(2, '0') : '00';
  const minutes = parts[1] ? parts[1].padStart(2, '0') : '00';

  return `${hours}:${minutes}`; // HH:MM formato 24h
});

// Ya no necesitamos opciones predefinidas para el selector de tiempo
// Ahora usamos entrada manual con formato HH:MM

// Nota: Funciones eliminadas para corregir errores// Combinar fecha y hora en un valor ISO
const combinedValue = computed(() => {
  if ((!selectedDate.value && props.showDate) || (!selectedTime.value && props.showTime)) {
    return '';
  }

  let value = '';

  if (props.showDate && selectedDate.value) {
    value = selectedDate.value;
  } else {
    // Si solo se muestra la hora, usamos la fecha actual
    const now = new Date();
    value = now.toISOString().split('T')[0];
  }

  if (props.showTime && selectedTime.value) {
    value = `${value}T${selectedTime.value}:00`;
  } else {
    // Si solo se muestra la fecha, agregamos tiempo cero
    value = `${value}T00:00:00`;
  }

  return value;
});

// Nota: Función eliminada para evitar duplicados

// Función para manejar clic en el campo de hora
// Nota: Función eliminada porque no se usa

// Generar días del mes actual para el calendario
const calendarDays = computed(() => {
  if (!selectedDate.value && !props.showDate) {
    return [];
  }

  const date = selectedDate.value
    ? new Date(selectedDate.value)
    : new Date();

  const year = date.getFullYear();
  const month = date.getMonth();

  // Primer día del mes (0-6, donde 0 es Domingo)
  const firstDayOfMonth = new Date(year, month, 1);
  // Ajustamos para que la semana comience el lunes (0 = lunes, 6 = domingo)
  const firstWeekday = (firstDayOfMonth.getDay() + 6) % 7;

  // Último día del mes
  const lastDayOfMonth = new Date(year, month + 1, 0).getDate();

  // Último día del mes anterior
  const lastDayOfPrevMonth = new Date(year, month, 0).getDate();

  const days = [];

  // Días del mes anterior
  for (let i = 0; i < firstWeekday; i++) {
    days.push({
      day: lastDayOfPrevMonth - firstWeekday + i + 1,
      month: month === 0 ? 11 : month - 1,
      year: month === 0 ? year - 1 : year,
      isCurrentMonth: false,
      isToday: false,
      isSelected: false
    });
  }

  // Días del mes actual
  const today = new Date();
  const isToday = (day: number) => {
    return year === today.getFullYear() &&
      month === today.getMonth() &&
      day === today.getDate();
  };

  const isSelected = (day: number) => {
    if (!selectedDate.value) return false;

    // Al construir la fecha de comparación debemos asegurarnos de que es UTC-compatible
    const selectedDateObj = new Date(selectedDate.value + 'T00:00:00');
    return year === selectedDateObj.getFullYear() &&
      month === selectedDateObj.getMonth() &&
      day === selectedDateObj.getDate();
  };

  for (let i = 1; i <= lastDayOfMonth; i++) {
    days.push({
      day: i,
      month: month,
      year: year,
      isCurrentMonth: true,
      isToday: isToday(i),
      isSelected: isSelected(i)
    });
  }

  // Días del mes siguiente
  const daysNeeded = 42 - days.length; // 6 filas * 7 días = 42

  for (let i = 1; i <= daysNeeded; i++) {
    days.push({
      day: i,
      month: month === 11 ? 0 : month + 1,
      year: month === 11 ? year + 1 : year,
      isCurrentMonth: false,
      isToday: false,
      isSelected: false
    });
  }

  return days;
});

// Nombre del mes actual y año
const currentMonthYear = computed(() => {
  const months = [
    'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
    'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
  ];

  const date = selectedDate.value
    ? new Date(selectedDate.value)
    : new Date();

  return `${months[date.getMonth()]} ${date.getFullYear()}`;
});

// Navegación entre meses
function prevMonth(): void {
  const date = selectedDate.value
    ? new Date(selectedDate.value)
    : new Date();

  date.setMonth(date.getMonth() - 1);

  if (selectedDate.value) {
    selectedDate.value = date.toISOString().split('T')[0];
  } else {
    // Solo actualizamos la vista, no la selección
    tempDate.value = date.toISOString().split('T')[0];
  }
}

function nextMonth(): void {
  const date = selectedDate.value
    ? new Date(selectedDate.value)
    : new Date();

  date.setMonth(date.getMonth() + 1);

  if (selectedDate.value) {
    selectedDate.value = date.toISOString().split('T')[0];
  } else {
    // Solo actualizamos la vista, no la selección
    tempDate.value = date.toISOString().split('T')[0];
  }
}

// Para manejar la navegación cuando no hay fecha seleccionada
const tempDate = ref(new Date().toISOString().split('T')[0]);

// Seleccionar día
function selectDay(day: CalendarDay): void {
  // Creamos la fecha con el ajuste de UTC para evitar problemas de zona horaria
  const date = new Date(Date.UTC(day.year, day.month, day.day));
  selectedDate.value = date.toISOString().split('T')[0];

  // Verificar si la fecha está dentro del rango permitido
  if (props.minDate && selectedDate.value < props.minDate) {
    selectedDate.value = props.minDate;
  }

  if (props.maxDate && selectedDate.value > props.maxDate) {
    selectedDate.value = props.maxDate;
  }

  // Actualizamos el modelo
  emit('update:modelValue', combinedValue.value);

  // Forzamos una actualización para que el calendario muestre correctamente el día seleccionado
  nextTick(() => {
    // Este tick garantiza que el DOM se actualice con el nuevo día seleccionado
  });

  // No cerramos el calendario automáticamente para permitir selecciones consecutivas
}

// Cerrar el calendario
function closeDatePicker(): void {
  showDatePicker.value = false;
}

// Abrir/cerrar selectores
function toggleDatePicker(): void {
  if (props.disabled || props.readOnly) return;
  showDatePicker.value = !showDatePicker.value;
  if (showDatePicker.value) {
    showTimePicker.value = false;
  }
}

// Funciones para manejar la entrada manual del tiempo
function handleTimeInput(value: string | number): void {
  // Convertir el valor a string si es número
  const stringValue = String(value);

  // Eliminamos cualquier carácter que no sea dígito o dos puntos
  const cleanValue = stringValue.replace(/[^\d:]/g, '');

  // Si está vacío, no hacemos nada
  if (!cleanValue) {
    selectedTime.value = '';
    timeInputHours.value = '';
    timeInputMinutes.value = '';
    return;
  }

  const parts = cleanValue.split(':');

  // Manejamos las horas
  if (parts[0]) {
    let hours = parseInt(parts[0]);
    // Validamos horas (0-23)
    if (isNaN(hours)) hours = 0;
    if (hours > 23) hours = 23;
    timeInputHours.value = hours.toString().padStart(2, '0');
  }

  // Manejamos los minutos
  if (parts.length > 1 && parts[1]) {
    let minutes = parseInt(parts[1]);
    // Validamos minutos (0-59)
    if (isNaN(minutes)) minutes = 0;
    if (minutes > 59) minutes = 59;
    timeInputMinutes.value = minutes.toString().padStart(2, '0');
  }

  // Actualizamos el valor completo
  if (timeInputHours.value) {
    if (timeInputMinutes.value) {
      selectedTime.value = `${timeInputHours.value}:${timeInputMinutes.value}`;
    } else {
      selectedTime.value = `${timeInputHours.value}:00`;
    }
  } else {
    selectedTime.value = '';
  }

  emit('update:modelValue', combinedValue.value);
}

// Función para gestionar el foco en la entrada de tiempo
function focusTimeInput(): void {
  if (props.disabled || props.readOnly) return;

  // Si no hay tiempo seleccionado, establecemos valores por defecto
  if (!selectedTime.value) {
    const now = new Date();
    timeInputHours.value = now.getHours().toString().padStart(2, '0');
    timeInputMinutes.value = '00';
    selectedTime.value = `${timeInputHours.value}:${timeInputMinutes.value}`;
  }
}

// Cerrar al hacer clic fuera
function onClickOutside(e: MouseEvent): void {
  if (datePickerRef.value && !datePickerRef.value.contains(e.target as Node)) {
    showDatePicker.value = false;
  }
  if (timePickerRef.value && !timePickerRef.value.contains(e.target as Node)) {
    showTimePicker.value = false;
  }
}

// Emitir cambios cuando se actualice algún valor
watch([selectedDate, selectedTime], () => {
  emit('update:modelValue', combinedValue.value);
});

// Reaccionar a cambios en modelValue
watch(() => props.modelValue, (newValue: string | undefined) => {
  if (newValue) {
    parseModelValue();
  } else {
    selectedDate.value = '';
    selectedTime.value = '';
  }
});

// Configurar listeners para cerrar al hacer clic fuera
watch([showDatePicker, showTimePicker], ([showDate, showTime]: [boolean, boolean]) => {
  if (showDate || showTime) {
    setTimeout(() => {
      document.addEventListener('click', onClickOutside);
    }, 0);
  } else {
    document.removeEventListener('click', onClickOutside);
  }
});
</script>

<template>
  <div class="datetime-picker">
    <div class="datetime-picker-inputs">
      <!-- Selector de fecha -->
      <div v-if="showDate" class="datetime-picker-date" ref="datePickerRef">
        <Input type="text" :value="displayDate" :placeholder="placeholder" :disabled="disabled" :readOnly="true"
          :required="required" @click="toggleDatePicker">
        <template #suffix>
          <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none"
            stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
            <line x1="16" y1="2" x2="16" y2="6"></line>
            <line x1="8" y1="2" x2="8" y2="6"></line>
            <line x1="3" y1="10" x2="21" y2="10"></line>
          </svg>
        </template>
        <template #label v-if="$slots.label">
          <slot name="label"></slot>
        </template>
        <template #help v-if="$slots.help">
          <slot name="help"></slot>
        </template>
        </Input>

        <!-- Calendario -->
        <div v-if="showDatePicker" class="datetime-picker-calendar">
          <div class="datetime-picker-calendar-header">
            <button type="button" class="datetime-picker-nav-btn" @click="prevMonth">
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none"
                stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <polyline points="15 18 9 12 15 6"></polyline>
              </svg>
            </button>
            <span class="datetime-picker-current-month">{{ currentMonthYear }}</span>
            <div class="datetime-picker-header-right">
              <button type="button" class="datetime-picker-nav-btn" @click="nextMonth">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none"
                  stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                  <polyline points="9 18 15 12 9 6"></polyline>
                </svg>
              </button>
              <button type="button" class="datetime-picker-close-btn" @click="closeDatePicker">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none"
                  stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                  <line x1="18" y1="6" x2="6" y2="18"></line>
                  <line x1="6" y1="6" x2="18" y2="18"></line>
                </svg>
              </button>
            </div>
          </div>

          <div class="datetime-picker-calendar-grid">
            <!-- Días de la semana (Lunes a Domingo) -->
            <div class="datetime-picker-weekday">Lu</div>
            <div class="datetime-picker-weekday">Ma</div>
            <div class="datetime-picker-weekday">Mi</div>
            <div class="datetime-picker-weekday">Ju</div>
            <div class="datetime-picker-weekday">Vi</div>
            <div class="datetime-picker-weekday">Sa</div>
            <div class="datetime-picker-weekday">Do</div>

            <!-- Días del mes -->
            <button v-for="(day, index) in calendarDays" :key="index" type="button" class="datetime-picker-day" :class="{
              'outside-month': !day.isCurrentMonth,
              'today': day.isToday,
              'selected': day.isSelected
            }" @click="selectDay(day)">
              {{ day.day }}
            </button>
          </div>
        </div>
      </div>

      <!-- Selector de hora con formato HH:MM -->
      <div v-if="showTime" class="datetime-picker-time" ref="timePickerRef">
        <div class="datetime-picker-time-input">
          <Input type="text" :modelValue="displayTime" :placeholder="showDate ? 'HH:MM' : placeholder"
            :disabled="disabled" :readOnly="props.readOnly" :required="required" @update:modelValue="handleTimeInput"
            @click="focusTimeInput" ref="timeInputRef">
          <template #suffix>
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none"
              stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <circle cx="12" cy="12" r="10"></circle>
              <polyline points="12 6 12 12 16 14"></polyline>
            </svg>
          </template>
          </Input>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
/* Usando @apply para utilizar las clases de Tailwind */
.datetime-picker {
  @apply w-full;
}

.datetime-picker-inputs {
  @apply flex gap-2;
}

.datetime-picker-date,
.datetime-picker-time {
  @apply relative flex-1;
}

.datetime-picker-calendar {
  @apply absolute top-full left-0 z-50 w-[300px] mt-1 bg-card border border-border rounded-lg shadow-lg p-3 text-sm;
}

.datetime-picker-calendar-header {
  @apply flex items-center justify-between pb-3 border-b border-border mb-2;
}

.datetime-picker-nav-btn {
  @apply bg-transparent border-none cursor-pointer text-muted-foreground p-1 rounded;
}

.datetime-picker-nav-btn:hover {
  @apply bg-muted;
}

.datetime-picker-close-btn {
  @apply bg-transparent border-none cursor-pointer text-muted-foreground p-1 rounded ml-1;
}

.datetime-picker-close-btn:hover {
  @apply bg-muted;
}

.datetime-picker-header-right {
  @apply flex items-center;
}

.datetime-picker-current-month {
  @apply font-semibold text-foreground;
}

.datetime-picker-calendar-grid {
  @apply grid grid-cols-7 gap-0.5;
}

.datetime-picker-weekday {
  @apply text-center py-2 font-semibold text-muted-foreground text-xs;
}

.datetime-picker-day {
  @apply flex justify-center items-center p-0 h-8 w-full text-sm bg-transparent border-none rounded cursor-pointer;
}

.datetime-picker-day:hover:not(.outside-month) {
  @apply bg-muted;
}

.datetime-picker-day.outside-month {
  @apply text-muted-foreground opacity-40;
}

.datetime-picker-day.today {
  @apply font-semibold border border-muted bg-secondary;
}

.datetime-picker-day.selected {
  @apply bg-primary text-primary-foreground font-medium;
}

.datetime-picker-time-list {
  @apply absolute top-full left-0 right-0 z-50 mt-1 bg-card border border-border rounded-lg shadow-lg max-h-[200px] overflow-y-auto;
}

.time-list-container {
  @apply flex flex-col;
}

.datetime-picker-time-option {
  @apply py-2 px-4 text-left bg-transparent border-none cursor-pointer text-sm text-foreground;
}

.datetime-picker-time-option:hover {
  @apply bg-muted;
}

.datetime-picker-time-option.selected {
  @apply bg-primary text-primary-foreground font-medium;
}
</style>
