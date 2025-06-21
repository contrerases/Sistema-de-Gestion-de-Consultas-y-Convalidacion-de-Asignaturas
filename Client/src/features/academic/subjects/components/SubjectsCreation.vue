<template>
  <div v-if="isOpen" class="fixed inset-0 flex items-center justify-center bg-black bg-opacity-50 z-50">
    <div class="bg-background border-2 border-border rounded-xl p-8 max-w-md w-full">
      <div>
        <h2 class="modal-title py-5">Crear Asignatura</h2>
        <div class="mb-4">
          <input v-model="newSubject.acronym" class="bg-input p-4 w-full uppercase" placeholder="Acrónimo (XXX-NNN)" />
        </div>
        <div class="mb-4">
          <input v-model="newSubject.name" class="bg-input p-4 w-full uppercase" placeholder="Nombre de la Asignatura" />
        </div>
        <div class="mb-4">
          <input v-model="newSubject.credits" type="number" class="bg-input p-4 w-full" placeholder="CRÉDITOS" />
        </div>
        <div class="mb-4">
          <select v-model="newSubject.id_department" class="bg-input p-4 w-full">
            <option value="" disabled>Selecciona un departamento</option>
            <option v-for="department in departments" :key="department.id" :value="department.id">
              {{ department.name }}
            </option>
          </select>
        </div>
      </div>
      <div class="modal-actions pt-5">
        <button @click="create" class="btn-primary">Crear</button>
        <button @click="close" class="btn-secondary">Cerrar</button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import type { SubjectPost } from '@/interfaces/subject_model';
import type {DepartmentResponse} from '@/interfaces/department_model';
import {getAllDepartments} from '@/shared/services/api/department_api';
import {onMounted} from 'vue';

// Props recibidas
const props = defineProps({
  isOpen: Boolean,
});


// Departamentos
const departments = ref<DepartmentResponse[]>([]);

async function getDepartmentsHandler() {
  try {
    departments.value = await getAllDepartments();
  } catch (error) {
    console.error('Error al obtener los departamentos:', error);
  }
}


// Emitir eventos de 'create' y 'close'
const emit = defineEmits(['create', 'close']);

// Modelo de la asignatura
const newSubject = ref<SubjectPost>({
  acronym: '',
  name: '',
  id_department: null,
  credits: null,
});

// Función para cerrar el modal
function close() {
  emit('close');
}

// Función para crear la asignatura y emitir el evento con los datos del formulario
function create() {
  if (newSubject.value.acronym && newSubject.value.name && newSubject.value.id_department && newSubject.value.credits) {
    emit('create', newSubject.value);
    newSubject.value = { acronym: '', name: '', id_department: 0, credits: 0 };
  }
}

onMounted(getDepartmentsHandler);


</script>

<style scoped lang="postcss">
.modal-overlay {
  @apply fixed inset-0 bg-black bg-opacity-80 flex justify-center items-center;
}

.modal-container {
  @apply bg-background p-20 rounded-lg shadow-lg w-2/3 flex flex-col justify-between;
}

.modal-title {
  @apply text-2xl font-bold mb-4 uppercase;
}

.modal-actions {
  @apply mt-4 flex justify-end;
}

.btn-primary {
  @apply bg-primary text-foreground px-4 py-2 rounded hover:bg-opacity-10 mr-2;
}

.btn-secondary {
  @apply bg-destructive text-foreground px-4 py-2 rounded hover:bg-destructive-hover;
}
</style>
