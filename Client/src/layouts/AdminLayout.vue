<template>
 <main class="main">
    <AdminSidebar/>
    <div class="content">
    </div>
 </main>
</template>

<script setup lang="ts" >
import AdminSidebar from '@/components/AdminSidebar.vue';
</script>

<style scoped lang="postcss">
    .main {
        @apply w-screen max-w-screen-2xl h-full mx-auto my-10 rounded-2xl flex flex-row;
    }
    .content {
        @apply w-9/12 h-screen;
    }

</style>