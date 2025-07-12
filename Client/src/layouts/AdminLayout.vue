<template>
 <main class="admin-main">
    <AdminSidebar/>
    <div class="admin-content">
        <RouterView />
    </div>
 </main>
</template>

<script setup lang="ts" >
import AdminSidebar from '@/shared/components/layout/AdminSidebar.vue';
</script>

<style scoped lang="postcss">
    .admin-main {
        @apply w-screen  h-[800px] max-w-screen-2xl  mx-auto  rounded-2xl flex flex-row border-2 border-border;
    }
    .admin-content {
        @apply w-9/12 overflow-y-auto ;
    }

</style>
