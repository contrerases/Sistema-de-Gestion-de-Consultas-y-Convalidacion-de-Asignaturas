<template>

  <AlertDialog :isOpen="showAlertDialog"  title="Error" :message="messageAlert" @close="toggleAlertDialog" />
  <SuccessDialog :isOpen="showSuccessDialog" title="Departamento Creado" :message="messageSuccess" @close="toggleSuccessDialog" />

  <DepartmentInsertDialog :isOpen="showCreateDepartmentDialog" @create="insertDepartmentHandler"
    @close="toggleInsertDepartmentDialog" />

  <main class="department-main">
    <div class="flex justify-between items-center">
      <h1 class="department-title">Departamentos</h1>
      <button @click="toggleInsertDepartmentDialog" class="bg-primary p-4 rounded-lg font-semibold hover:opacity-80">
        Agregar departamento
      </button>
    </div>

    <div class="department-content">
      <DepartmentTable />
    </div>
  </main>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import DepartmentTable from '@/features/academic/departments/components/DepartmentTable.vue';
import DepartmentInsertDialog from '@/features/academic/departments/components/DepartmentInsertDialog.vue';

import type { DepartmentPost } from '@/interfaces/department_model';
import { insertDepartment } from '@/shared/services/api/department_api';

import AlertDialog from '@/shared/components/dialogs/AlertDialog.vue';
import SuccessDialog from '@/shared/components/dialogs/SuccessDialog.vue';

// Estado del nuevo departamento
const newDepartment = ref<DepartmentPost>({
  name: '',
});

// Estados para mostrar/ocultar diálogos
const showCreateDepartmentDialog = ref(false);

const messageAlert = ref('');
const messageSuccess = ref('');
const showAlertDialog = ref(false);
const showSuccessDialog = ref(false);

// Funciones para alternar la visibilidad de los diálogos
function toggleInsertDepartmentDialog() {
  showCreateDepartmentDialog.value = !showCreateDepartmentDialog.value;
}

function toggleAlertDialog() {
  showAlertDialog.value = !showAlertDialog.value;
}

function toggleSuccessDialog() {
  showSuccessDialog.value = !showSuccessDialog.value;
}


async function insertDepartmentHandler(department: DepartmentPost) {
  try {
    await insertDepartment(department);  
    messageSuccess.value = 'Departamento creado correctamente';
    toggleInsertDepartmentDialog();
    toggleSuccessDialog();
     
  } catch (error) {
    toggleInsertDepartmentDialog();
    messageAlert.value = 'Error al crear departamento';
    toggleAlertDialog(); 
  }
}


</script>

<style scoped lang="postcss">
.department-main {
  @apply flex flex-col mx-5 px-10 mt-16 h-screen relative;
}

.department-title {
  @apply text-5xl font-bold tracking-tight;
}

.department-content {
  @apply m-0 pt-10;
}
</style>
