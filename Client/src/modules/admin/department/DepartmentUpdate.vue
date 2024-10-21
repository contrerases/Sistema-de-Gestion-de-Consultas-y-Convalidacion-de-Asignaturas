<template>
    <div v-if="isOpen" class="fixed inset-0 flex items-center justify-center bg-black bg-opacity-50">
        <div class="bg-background border-2 border-border rounded-xl p-8 max-w-md w-full">

            <div>
                <h2 class="modal-title py-5">Actualizar Departamento</h2>
                <input v-model="editableDepartment.name" class="bg-input p-4 w-full" placeholder="Nombre del Departamento" />
            </div>


            <div class="modal-actions pt-5">
                <button @click="update" class="btn-primary">Actualizar</button>
                <button @click="close" class="btn-secondary">Cerrar</button>
            </div>
        </div>
    </div>
</template>

<script setup lang="ts">

import { ref, watch } from 'vue';

import type { DepartmentResponse, DepartmentPost, DepartmentBase } from '@/interfaces/department_model';


const props = defineProps({
    isOpen: Boolean,
    department: {
        type: Object as () => DepartmentBase,
        required: true
  }
});


const editableDepartment = ref({ ...props.department });

watch(
    () => props.department,
    (newVal) => {
        editableDepartment.value = { ...newVal };
    },
    { immediate: true }
);



const emit = defineEmits(['close', 'update']);


function close() {
    emit('close');
}

function update() {
    emit('update', editableDepartment.value);
}





</script>


<style scoped lang="postcss">

.modal-overlay {
    @apply fixed inset-0 bg-black bg-opacity-80 flex justify-center items-center;
  }
  
  .modal-container {
    @apply bg-background p-20 rounded-lg shadow-lg w-2/3  flex flex-col justify-between;
  }
  
  .modal-title {
    @apply text-2xl font-bold mb-4 uppercase;
  }
  
  .form-group {
    @apply mb-4;
  }
  
  .form-label {
    @apply block text-sm font-medium text-foreground;
  }
  
  .form-input {
    @apply mt-1 p-2 border rounded w-full bg-input;
  }
  
  .form-checkbox {
    @apply mt-1;
  }
  
  .date-inputs {
    @apply flex space-x-2;
  }
  
  .modal-actions {
    @apply mt-4 flex justify-end;
  }
  
  .btn-primary {
    @apply bg-primary text-foreground px-4 py-2 rounded hover:bg-opacity-10 mr-2;
  }
  
  .btn-secondary {
    @apply bg-destructive text-foreground px-4 py-2 rounded hover:bg-destructive-hover ;
  }

</style>