<template>
  <LoadingSpinner v-if="isLoading"/>
  <div class="container" v-else>
    <div class="overflow-x-auto">
      <table class="table">
        <thead class="thead">
          <tr class="tr-up">
            <th class="th">Nombre</th>
          </tr>
        </thead>
        <tbody class="tbody">
          <tr class="tr" v-for="curriculum_course in curriculum_courses" :key="curriculum_course.id" >
            <td class="td">{{ curriculum_course.name }}</td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

  <script setup lang="ts">
  import { ref, onMounted } from 'vue';
  import type { CurriculumCourseResponse } from '@/interfaces/curriculum_course_model';
  import { useCurriculumCourseStore } from '@/stores/curriculum_course_store';
  
  import LoadingSpinner from '@/common/LoadingSpinner.vue';

  let isLoading = ref<boolean>(true);
  
  const curriculum_courses = ref<CurriculumCourseResponse[]>([]);

  const curriculum_coursesStore = useCurriculumCourseStore();

  
  async function getCurriculumCoursesHandler() {
    try {
        await curriculum_coursesStore.getCurriculumCoursesStore();
        curriculum_courses.value = curriculum_coursesStore.allCurriculumCourses;
    } 
    catch (error) {
        console.error('Error al obtener convalidaciones:', error);
    }
    finally {
        isLoading.value = false;
    }
  }  

  onMounted(getCurriculumCoursesHandler);


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
   @apply text-foreground;
 }

 </style>
 