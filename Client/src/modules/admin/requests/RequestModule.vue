<template>
    <main class="request-main">
        <h1 class="request-title">Solicitudes</h1>
        <div class="request-content">
            <RequestReviewCardList />
        </div>
    </main>
</template>

<script setup lang="ts">
import RequestReviewCardList from '@/modules/admin/requests/RequestReviewCardList.vue';
</script>

<style scoped lang="postcss">

.request-main {
  @apply flex flex-col mx-5 px-10 mt-16 h-screen relative ;  
}

.request-title {
  @apply text-5xl text-foreground font-bold mb-10 font-mono;
}

.request-content {
    @apply m-0 p-0;
}

</style>