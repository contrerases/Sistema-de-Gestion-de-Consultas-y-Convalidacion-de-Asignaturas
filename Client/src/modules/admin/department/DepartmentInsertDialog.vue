<template>
  <div v-if="isOpen" class="fixed inset-0 flex items-center justify-center bg-black bg-opacity-50 z-50">
    <div class="bg-background border-2 border-border rounded-xl p-8 max-w-md w-full">
      <div>
        <h2 class="modal-title py-5">Crear Departamento</h2>
        <input v-model="newDepartment.name" class="bg-input p-4 w-full uppercase" placeholder="Nombre del Departamento" />
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
import type { DepartmentPost } from '@/interfaces/department_model';

const props = defineProps({
  isOpen: Boolean
});

const newDepartment = ref<DepartmentPost>({
  name: ''
});

const emit = defineEmits(['close', 'create']);

function close() {
  emit('close');
}

function create() {
  if (newDepartment.value.name.trim() !== '') {
    emit('create', newDepartment.value);
    newDepartment.value.name = '';
  }
}
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
