<template>
  <div v-if="isOpen" class="fixed inset-0 flex items-center justify-center bg-black bg-opacity-50 z-50">
    <div class="bg-background border-2 border-border rounded-xl p-8 max-w-md w-full">
      <div>
        <h2 class="modal-title py-5">Filtrar Historial de Solicitudes</h2>
        
        <!-- Campo para nombre del estudiante
        <div class="mb-4">
          <label for="name_student" class="block text-foreground font-semibold mb-2">Nombre del Estudiante</label>
          <input
            v-model="filters.name_student"
            id="name_student"
            class="bg-input p-4 w-full"
            placeholder="Juan Pérez"
          />
        </div> -->

        <!-- Campo para RUT del estudiante -->
        <div class="mb-4">
          <label for="rut_student" class="block text-foreground font-semibold mb-2 uppercase">RUT </label>
          <input
            v-model="filters.rut_student"
            id="rut_student"
            class="bg-input p-4 w-full"
            placeholder="12345678-9"
          />
        </div>

        <!-- Campo para rol del estudiante -->
        <div class="mb-4">
          <label for="rol_student" class="block text-foreground font-semibold mb-2 uppercase">Rol</label>
          <input
            v-model="filters.rol_student"
            id="rol_student"
            class="bg-input p-4 w-full"
            placeholder="202210101"
          />
        </div>

        <!-- Campo para cota inferior de fecha -->
        <div class="mb-4">
          <label for="date_lower_bound" class="block text-foreground font-semibold mb-2 uppercase">Desde (Fecha Inferior)</label>
          <input
            v-model="filters.date_lower_bound"
            id="date_lower_bound"
            type="date"
            class="bg-input p-4 w-full"
          />
        </div>

        <!-- Campo para cota superior de fecha -->
        <div class="mb-4">
          <label for="date_upper_bound" class="block text-foreground font-semibold mb-2 uppercase">Hasta (Fecha Superior)</label>
          <input
            v-model="filters.date_upper_bound"
            id="date_upper_bound"
            type="date"
            class="bg-input p-4 w-full"
          />
        </div>
      </div>
      
      <!-- Acciones del modal -->
      <div class="modal-actions pt-5">
        <button @click="applyFilters" class="btn-primary">Aplicar Filtros</button>
        <button @click="close" class="btn-secondary">Cerrar</button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, defineProps, defineEmits } from 'vue';
import type { RequestFiltered } from '@/interfaces/request_model';

// Props que recibe el modal
const props = defineProps({
  isOpen: Boolean,
  initialFilters: Object as () => RequestFiltered,
});

// Eventos para cerrar o aplicar filtros
const emit = defineEmits(['close', 'applyFilters']);

// Filtros iniciales reactivos
const filters = ref<RequestFiltered>({ ...props.initialFilters });

// Función para cerrar el modal
function close() {
  emit('close');
}

// Función para aplicar filtros
function applyFilters() {
  emit('applyFilters', filters.value);
}
</script>

<style scoped lang="postcss">
.modal-overlay {
  @apply fixed inset-0 bg-black bg-opacity-80 flex justify-center items-center;
}

.modal-container {
  @apply bg-background border-2 border-border rounded-xl p-8 max-w-md w-full;
}

.modal-title {
  @apply text-2xl font-bold uppercase mb-4;
}

.modal-actions {
  @apply mt-4 flex justify-end;
}

.btn-primary {
  @apply bg-primary text-white px-4 py-2 rounded hover:bg-opacity-90 mr-2;
}

.btn-secondary {
  @apply bg-destructive text-white px-4 py-2 rounded hover:bg-destructive-hover;
}

label {
  @apply text-sm font-semibold mb-1;
}

input,
select {
  @apply bg-input text-foreground p-3 rounded border border-border focus:outline-none focus:ring-2 focus:ring-primary;
}
</style>
