<template>
  <div v-if="isOpen" class="fixed inset-0 flex items-center justify-center bg-black bg-opacity-50 z-50">
    <div class="bg-background border-2 border-border rounded-xl p-8 max-w-md w-full">
      <div>
        <h2 class="modal-title py-5">Actualizar Asignatura</h2>
        
        <!-- Campo para acrónimo -->
        <div class="mb-4">
          <input v-model="subject.acronym" class="bg-input p-4 w-full uppercase" placeholder="Acrónimo (XXX-NNN)" />
        </div>
        
        <!-- Campo para nombre -->
        <div class="mb-4">
          <input v-model="subject.name" class="bg-input p-4 w-full uppercase" placeholder="Nombre de la Asignatura" />
        </div>
        
        <!-- Campo para créditos -->
        <div class="mb-4">
          <input v-model="subject.credits" type="number" class="bg-input p-4 w-full" placeholder="Créditos" />
        </div>
        
        <!-- Campo de selección de departamento -->
        <div class="mb-4">
          <select v-model="subject.id_department" class="bg-input p-4 w-full">
            <option value="" disabled selected hidden>Selecciona un departamento</option>
            <option v-for="department in departments" :key="department.id" :value="department.id">
              {{ department.name }}
            </option>
          </select>
        </div>
      </div>
      
      <!-- Acciones del modal -->
      <div class="modal-actions pt-5">
        <button @click="update" class="btn-primary">Guardar Cambios</button>
        <button @click="close" class="btn-secondary">Cerrar</button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, watch, defineProps, defineEmits , onMounted} from 'vue';
import type { SubjectUpdate } from '@/interfaces/subject_model';
import type { DepartmentResponse } from '@/interfaces/department_model';

import {getAllDepartments} from '@/services/department_api';





// Props que recibe el modal
const props = defineProps({
  isOpen: Boolean,
  initialSubject: Object as () => SubjectUpdate,
});

// Eventos para cerrar o actualizar
const emit = defineEmits(['close', 'update']);

// Inicializar el objeto `subject` como reactivo
const subject = ref<SubjectUpdate>({ ...props.initialSubject });

// Verificar y actualizar `subject` cada vez que cambie `initialSubject`
watch(
  () => props.initialSubject,
  (newSubject) => {
    subject.value = { ...newSubject };
  },
  { immediate: true }
);

// Funciones de cierre y actualización
function close() {
  emit('close');
}

function update() {
  emit('update', subject.value); // Emitir el objeto actualizado
}

// Lista de departamentos para el select
const departments = ref<DepartmentResponse[]>([]);

// Cargar los departamentos al montar el componente

async function getAllDepartmentsHandler() {
 try {
  departments.value = await getAllDepartments();
 }
 catch (error) {
   console.error(error);
 }
}

onMounted(getAllDepartmentsHandler)


// Aquí puedes agregar lógica para cargar los departamentos si es necesario
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
  @apply bg-primary text-white px-4 py-2 rounded hover:bg-opacity-10 mr-2;
}

.btn-secondary {
  @apply bg-destructive text-white px-4 py-2 rounded hover:bg-destructive-hover;
}
</style>
