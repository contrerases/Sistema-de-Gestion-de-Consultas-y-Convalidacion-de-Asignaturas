<template>

    <CurriculumCourseInsertDialog :isOpen="showInsertDialog" @close="closeInsertDialog" @create="insertCurriculumCourses"/>


    <main class="courses-main">
        <div class="flex justify-between">
          <h1 class="courses-title"> Asignaturas Curriculares</h1>
          <button @click="openInsertDialog" class="bg-primary rounded-lg border border-border px-5">
            Crear Asignatura Curricular
          </button>
        </div>
        <div class="courses-content">   
            <CurriculumCourseTable />
        </div>
    </main>
</template>

<script lang="ts" setup>
import CurriculumCourseTable from '@/modules/admin/curriculum_courses/CurriculumCoursesTable.vue';
import CurriculumCourseInsertDialog from '@/modules/admin/curriculum_courses/CurriculumCourseInsertDialog.vue';
import type { CurriculumCoursePost } from '@/interfaces/curriculum_course_model';
import { insertCurriculumCourse, getAllCurriculumCourses } from '@/services/curriculm_course_api';
import { ref } from 'vue';


const showInsertDialog = ref<boolean>(false);

function openInsertDialog() {
  showInsertDialog.value = true;
}

function closeInsertDialog() {
  showInsertDialog.value = false;
}




async function insertCurriculumCourses(curriculum_course : CurriculumCoursePost) {
  try {
    await insertCurriculumCourse(curriculum_course);
    await getAllCurriculumCourses();
  } 
  catch (error) {
    console.error('Error al insertar asignatura curricular:', error);
  }
  
}



</script>


<style scoped lang="postcss">

.courses-main {
  @apply flex flex-col mx-5 px-10 mt-16 h-screen relative ;  
}

.courses-title {
  @apply text-5xl font-bold tracking-tight ; 
}

.courses-content {
    @apply m-0 pt-10;
}

</style>