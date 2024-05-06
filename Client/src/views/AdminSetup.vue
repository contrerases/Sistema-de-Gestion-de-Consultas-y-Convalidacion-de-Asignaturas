<script setup lang="ts">
import { useRouter } from 'vue-router';

const router = useRouter();

function goToSubject() {
  router.push('admin/subjects');
}

function goToWorkshops() {
  router.push('admin/workshops');
}

function goToCurriculumCourses() {
  router.push('admin/curriculum_courses');
}

function goToConvalidations() {
  router.push('admin/convalidations');
}

</script>


<template>
  <main class="h-auto m-20 grid grid-cols-5">
    <div class="col-span-1s"></div>
    <div class="col-span-4 bg- h-[700px] flex gap-10 m-auto">
      <button @click="goToSubject" class="square">Asignaturas</button>
      <button class="square">Talleres</button>
      <button class="square">Malla curricular</button>
      <button @click="goToConvalidations" class="square">Convalidaciones</button>
    </div>
  </main>
</template>

<style lang="postcss">
.square {
  @apply w-[200px] h-[200px] bg-primary opacity-90 rounded-2xl text-center flex items-center justify-center font-mono;
}
</style>
