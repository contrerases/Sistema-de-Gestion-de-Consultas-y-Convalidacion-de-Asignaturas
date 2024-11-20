<template>
    <main class="history-main">
      <h1 class="history-title">Historial de Convalidaciones</h1>
        <div class="history-content">   
            <HistoryListStudent/>
        </div>
    </main>
</template>

<script setup lang="ts">
  import HistoryListStudent from '@/modules/student/history/HistoryListStudent.vue';
</script>

<style scoped lang="postcss">

.history-main {
  @apply flex flex-col mx-5 px-10 pt-16 h-screen relative ;  
}

.history-title {
  @apply text-5xl font-bold tracking-tight ; 
}

.history-content {
    @apply m-0 pt-10;
}

</style>