<template>
    <main class="subjects-main">
        <h1 class="subjects-title">Asignaturas</h1>
        <div class="subjects-content">   
            <SubjectTable />
        </div>
    </main>
</template>

<script setup lang="ts">
import SubjectTable from '@/modules/admin/subjects/SubjectTable.vue';
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