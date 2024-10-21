<template>

  

    <main class="subjects-main">
      <SubjectsCreation 
      :visible="isModalVisible"
        @close="isModalVisible = false"
        @insert="refresh"
      />
       <div class="flex justify-between border-b pb-5 mb-5">
        <h1 class="subjects-title">Asignaturas</h1>
        <button @click="createModal" class="bg-primary rounded-lg border border-border p-5">
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
import SubjectTable from '@/modules/admin/subjects/SubjectsTable.vue';
import SubjectsCreation from '@/modules/admin/subjects/SubjectsCreation.vue';

const isModalVisible = ref(false);

const createModal = () => {
  isModalVisible.value = true;
};


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