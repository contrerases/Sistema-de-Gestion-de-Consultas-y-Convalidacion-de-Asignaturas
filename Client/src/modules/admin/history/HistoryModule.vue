<template>
    <main class="history-main">
        <h1 class="history-title">Solicitudes</h1>
        <div class="history-content">
            <HistoryViewCardList/>
        </div>
    </main>
</template>

<script setup lang="ts">
import HistoryViewCardList from '@/modules/admin/history/HistoryViewCardList.vue';
</script>

<style scoped lang="postcss">

.history-main {
  @apply flex flex-col mx-5 px-10 mt-16 h-full relative ;  
}

.history-title {
  @apply text-5xl text-foreground font-bold mb-10;
}

.history-content {
    @apply m-0 p-0;
}

</style>