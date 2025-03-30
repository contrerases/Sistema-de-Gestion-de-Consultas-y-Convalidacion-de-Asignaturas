<template>
    <main class="request-main">
        <h1 class="request-title">Solicitudes pendientes</h1>
        <div class="flex justify-between border-b pb-5 mb-5"></div>
        <div class="request-content">
            <RequestsReviewList />
        </div>
    </main>
</template>

<script setup lang="ts">
import RequestsReviewList from '@/modules/admin/requests/RequestsReviewList.vue';
</script>

<style scoped lang="postcss">

.request-main {
  @apply flex flex-col mx-5 px-10 mt-16 h-screen relative ;  
}

.request-title {
  @apply text-5xl font-bold tracking-tight;
}

.request-content {
    @apply m-0 p-0;
}

</style>