<template>
    <main class="convalidation-main">
        <h1 class="convalidation-title">Solicitudes</h1>
        <div class="convalidation-content">
            <ConvalidationsViewCardList />
        </div>
    </main>
</template>

<script setup lang="ts">
import ConvalidationsViewCardList from '@/modules/admin/convalidations/ConvalidationsViewCardList.vue';
</script>

<style scoped lang="postcss">

.convalidation-main {
  @apply flex flex-col mx-5 px-10 mt-16 h-full relative ;  
}

.convalidation-title {
  @apply text-5xl text-foreground font-bold mb-10;
}

.convalidation-content {
    @apply m-0 p-0;
}

</style>