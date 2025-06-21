<template>
    <main class="workshops-main">
        <h1 class="workshops-title">Talleres</h1>
        <div class="workshops-content">
            <WorkshopsList/>
        </div>
    </main>
</template>

<script setup lang="ts">
import  WorkshopsList from '@/features/workshops/WorkshopsListS.vue';
</script>

<style scoped lang="postcss">

.workshops-main {
  @apply flex flex-col mx-5 px-10 mt-16 h-screen relative ;  
}

.workshops-title {
  @apply text-5xl text-foreground font-bold mb-10 font-mono border-b pb-5; 
}

.workshops-content {
    @apply m-0 p-0;
}

</style>