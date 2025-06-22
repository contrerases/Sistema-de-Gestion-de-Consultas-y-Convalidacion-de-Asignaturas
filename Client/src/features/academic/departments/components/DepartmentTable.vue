<template>

  <AlertDialog :isOpen="showAlertDialog" title="Error" :message="messageAlert" @close="toggleAlertDialog" />
  
  <SuccessDialog :isOpen="showSuccessDialog" title="Departamento editado"
    :message="messageSuccess" @close="toggleSuccessDialog"/>

  <DepartmentUpdateDialog :isOpen="showUpdateDepartmentDialog" :department="selectedDepartment"
    @close="toggleUpdateDepartmentDialog" @update="updateDepartmentHandler" />


  <div class="container">
    <div class="overflow-x-auto">
      <table class="table">
        <thead class="thead">
          <tr class="tr-up">
            <th class="th">Nombre</th>
            <th class="th">
              <Icon class="icon" icon="uiw:setting" />
            </th>
          </tr>
        </thead>
        <tbody class="tbody">
          <tr class="tr" v-for="department in departments" :key="department.id">
            <td class="td">{{ department.name }}</td>
            <td class="td">
              <button @click="openUpdateDialog(department)">
                <Icon icon="akar-icons:pencil" />
              </button>
            </td>

          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';
import type { DepartmentResponse, DepartmentPost, DepartmentBase } from '@/interfaces/department_model';

import { getAllDepartments, updateDepartment } from '@/shared/services/api/department_api';

import { Icon } from '@iconify/vue';

import DepartmentUpdateDialog from '@/features/academic/departments/components/DepartmentUpdateDialog.vue';
import AlertDialog from '@/shared/components/dialogs/AlertDialog.vue';
import SuccessDialog from '@/shared/components/dialogs/SuccessDialog.vue';



const departments = ref<DepartmentResponse[]>([]);



// API Handler

async function getDepartmentsHandler() {
  try {
    departments.value = await getAllDepartments();
  }
  catch (error) {
    console.error('Error al obtener departamentos:', error);
  }
}


async function updateDepartmentHandler(updatedDepartment: DepartmentBase) {

  try {
    await updateDepartment(updatedDepartment.id, updatedDepartment);
    getDepartmentsHandler();
    toggleUpdateDepartmentDialog();
    messageSuccess.value = 'Departamento actualizado correctamente';
    toggleSuccessDialog();
  }
  catch (error) {
    messageAlert.value = 'Error al actualizar departamento';
    toggleUpdateDepartmentDialog();
    toggleAlertDialog();
  }
}


// Update Dialog

const selectedDepartment = ref<DepartmentBase>({
  id: 0,          
  name: '',      
});

const showUpdateDepartmentDialog = ref(false);

function openUpdateDialog(department: DepartmentBase) {
  selectedDepartment.value = department;
  showUpdateDepartmentDialog.value = true;
}

function toggleUpdateDepartmentDialog() {
  showUpdateDepartmentDialog.value = !showUpdateDepartmentDialog.value;
}

// Success Dialog

const showSuccessDialog = ref(false);
const messageSuccess = ref('');

function toggleSuccessDialog() {
  showSuccessDialog.value = !showSuccessDialog.value;
}

// Alert Dialog

const showAlertDialog = ref(false);
const messageAlert = ref('');

function toggleAlertDialog() {
  showAlertDialog.value = !showAlertDialog.value;
}



onMounted(getDepartmentsHandler);






</script>

<style scoped lang="postcss">
.container {
  @apply w-full m-0 p-2 border border-border rounded-3xl;
}

.table {
  @apply min-w-full bg-background;
}

.tbody {
  @apply text-foreground text-sm font-light;
}

.thead {
  @apply bg-background text-foreground uppercase text-sm leading-normal border border-transparent;
}

.th {
  @apply py-3 px-6 text-left;
}

.td {
  @apply py-3 px-6 text-left whitespace-nowrap;
}

.tr {
  @apply border-b border-border;
}

.tr-up {
  @apply border-b border-border;
}

.tr:last-child {
  @apply border-b border-transparent;
}


.icon {
  @apply text-foreground text-xl;
}

.acronym {
  @apply font-bold;
}
</style>
