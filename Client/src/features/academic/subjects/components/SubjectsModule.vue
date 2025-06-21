<template>

    <SubjectsCreation 
    :isOpen="showSubjectCreationModal"
    @close="toggleSubjectCreationModal"
    @create="insertSubjectHandler"
  />

  <AlertDialog
    :isOpen="showAlertDialog"
    @close="toggleAlertDialog"
    :message="messageAlert"
  />

  <SuccessDialog
    :isOpen="showSuccessDialog"
    @close="toggleSuccessDialog"
    :message="messageSuccess"
  />

    <main class="subjects-main">
     
       <div class="flex justify-between border-b pb-5 mb-5">
        <h1 class="subjects-title">Asignaturas</h1>
        <button @click="toggleSubjectCreationModal" class="bg-primary rounded-lg border border-border p-5">
          Añadir asignatura
        </button>
       </div>
        <div class="subjects-content">
            <SubjectTable />
        </div>
    </main>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import SubjectTable from '@/features/academic/subjects/components/SubjectsTable.vue';
import SubjectsCreation from '@/features/academic/subjects/components/SubjectsCreation.vue';

import type { SubjectPost } from '@/interfaces/subject_model';

import AlertDialog from '@/common/dialogs/AlertDialog.vue';
import SuccessDialog from '@/common/dialogs/SuccessDialog.vue';

import { insertSubject } from '@/shared/services/api/subject_api';

const showSubjectCreationModal = ref(false);
const messageAlert = ref('');
const messageSuccess = ref('');
const showAlertDialog = ref(false);
const showSuccessDialog = ref(false);


function toggleSubjectCreationModal() {
  showSubjectCreationModal.value = !showSubjectCreationModal.value;
}

function toggleAlertDialog() {
  showAlertDialog.value = !showAlertDialog.value;
}

function toggleSuccessDialog() {
  showSuccessDialog.value = !showSuccessDialog.value;
}

async function insertSubjectHandler(subject: SubjectPost) {
  try {
    await insertSubject(subject);
    messageSuccess.value = 'Asignatura creada correctamente';
    toggleSubjectCreationModal()
    toggleSuccessDialog();
  } catch (error) {
    toggleSubjectCreationModal()
    messageAlert.value = 'Error al crear la asignatura';
    toggleAlertDialog();
  }
}

</script>

<style scoped lang="postcss">

.subjects-main {
  @apply flex flex-col mx-5 px-10 mt-16 h-screen relative ;  
}

.subjects-title {
  @apply text-5xl font-bold tracking-tight ; 
}

.subjects-content {
    @apply m-0 pt-10;
}

</style>