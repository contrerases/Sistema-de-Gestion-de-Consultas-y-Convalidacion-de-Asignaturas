<template>
    <div class="container">
      <div class="overflow-x-auto">
        <table class="table">
          <thead class="thead">
            <tr class="tr-up">
              <th class="th">Sigla</th>
              <th class="th">Nombre</th>
              <th class="th">Departamento</th>
              <th class="th">Créditos</th>
              <th class="th"><Icon class="icon" icon="uiw:setting"/></th>
            </tr>
          </thead>
          <tbody class="tbody">
            <tr class="tr" v-for="subject in subjects" :key="subject.id" >
              <td class="td acronym">{{ subject.acronym }}</td>
              <td class="td">{{ subject.name }}</td>
              <td class="td">{{ subject.department_name }}</td>
              <td class="td">{{ subject.credits }}</td>
              <td class="td">
                <button @click="deleteSubjectHandler(subject.id)">
                  <Icon class="icon"icon="mdi:trash-can" />
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
  import type { SubjectResponse } from '@/interfaces/subject_model'
  import { useSubjectsStore } from '@/stores/subject_store';

  import { Icon } from '@iconify/vue';
  
  
  const subjects = ref<SubjectResponse[]>([]);

  const subjectsStore = useSubjectsStore();



  
  

  async function getSubjectsStoreHandler() {
    try {
        await subjectsStore.getSubjectsStore();
        subjects.value = subjectsStore.allSubjects;
       
    } 
    catch (error) {
        console.error('Error al obtener convalidaciones:', error);
    }
  }  

  async function deleteSubjectHandler(id: number) {
    try {
        await subjectsStore.deleteSubjectStore(id);
        await getSubjectsStoreHandler();
    } 
    catch (error) {
        console.error('Error al eliminar el subject:', error);
    }
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
  