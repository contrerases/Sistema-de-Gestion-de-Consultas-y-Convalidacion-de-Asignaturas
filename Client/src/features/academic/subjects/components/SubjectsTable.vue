<template>


  <SubjectUpdateDialog :isOpen="showSubjectUpdateDialog" @close="toggleSubjectUpdateDialog"
    @update="updateSubjectHandler" :initialSubject="selectedSubject" />

  <AlertDialog :isOpen="showAlertDialog" title="Error" :message="messageAlert" @close="toggleAlertDialog" />

  <SuccessDialog :isOpen="showSuccessDialog" title="Asignatura editada" :message="messageSuccess"
    @close="toggleSuccessDialog" />


  <div class="container">
    <div class="overflow-x-auto">
      <table class="table">
        <thead class="thead">
          <tr class="tr-up">
            <th class="th">Sigla</th>
            <th class="th">Nombre</th>
            <th class="th">Departamento</th>
            <th class="th">Créditos</th>
            <th class="th">
              <Icon class="icon" icon="uiw:setting" />
            </th>
          </tr>
        </thead>
        <tbody class="tbody">
          <tr class="tr" v-for="subject in subjects" :key="subject.id">
            <td class="td acronym">{{ subject.acronym }}</td>
            <td class="td">{{ subject.name }}</td>
            <td class="td">{{ subject.department_name }}</td>
            <td class="td">{{ subject.credits }}</td>
            <td class="td">
              <button @click="openSubjectHandler(subject)">
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
import type { SubjectResponse, SubjectUpdate } from '@/interfaces/subject_model'
import { useSubjectsStore } from '@/shared/stores/subject_store';

import { updateSubject } from '@/shared/services/api/subject_api';

import SubjectUpdateDialog from '@/features/academic/subjects/components/SubjectUpdateDialog.vue';

import AlertDialog from '@/common/dialogs/AlertDialog.vue';
import SuccessDialog from '@/common/dialogs/SuccessDialog.vue';






import { Icon } from '@iconify/vue';


const subjects = ref<SubjectResponse[]>([]);

const subjectsStore = useSubjectsStore();


const showAlertDialog = ref(false);
const messageAlert = ref('');

const showSuccessDialog = ref(false);
const messageSuccess = ref('');



function toggleAlertDialog() {
  showAlertDialog.value = !showAlertDialog.value;
}

function toggleSuccessDialog() {
  showSuccessDialog.value = !showSuccessDialog.value;
}



async function updateSubjectHandler(subject: SubjectUpdate) {
  try {
    await updateSubject(subject);
    toggleSubjectUpdateDialog();
    messageSuccess.value = 'Asignatura actualizada correctamente';
    toggleSuccessDialog();
  }
  catch (error) {
    toggleSubjectUpdateDialog();
    messageAlert.value = 'Error al actualizar asignatura';
    toggleAlertDialog();

  }
}


async function getSubjectsStoreHandler() {
  try {
    await subjectsStore.getSubjectsStore();
    subjects.value = subjectsStore.allSubjects;

  }
  catch (error) {
    console.error('Error al obtener convalidaciones:', error);
  }
}


const showSubjectUpdateDialog = ref(false);
const selectedSubject = ref<SubjectUpdate | null>(null);

function toggleSubjectUpdateDialog() {
  showSubjectUpdateDialog.value = !showSubjectUpdateDialog.value;
}

function openSubjectHandler(subject: SubjectUpdate) {
  selectedSubject.value = subject;
  toggleSubjectUpdateDialog();
}










onMounted(getSubjectsStoreHandler);


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
  @apply py-3 px-6 text-left whitespace-nowrap uppercase;
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