<template>
    <main class="courses-main">
        <h1 class="courses-title">Curriculum Course</h1>
        <div class="courses-content">   
            <CurriculumCourseTable />
        </div>
    </main>
</template>

<script setup lang="ts">
import CurriculumCourseTable from '@/modules/admin/curriculum_courses/CurriculumCoursesTable.vue';
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