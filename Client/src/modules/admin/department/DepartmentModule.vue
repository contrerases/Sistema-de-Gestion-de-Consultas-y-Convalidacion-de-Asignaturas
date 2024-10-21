<template>
    <main class="department-main">
        <h1 class="department-title">Departamentos</h1>
        <div class="department-content">   
            <DepartmentTable />
        </div>
    </main>
</template>

<script setup lang="ts">
import DepartmentTable from '@/modules/admin/department/DepartmentTable.vue';
</script>

<style scoped lang="postcss">

.department-main {
  @apply flex flex-col mx-5 px-10 mt-16 h-screen relative ;  
}

.department-title {
  @apply text-5xl font-bold tracking-tight ; 
}

.department-content {
    @apply m-0 pt-10;
}

</style>