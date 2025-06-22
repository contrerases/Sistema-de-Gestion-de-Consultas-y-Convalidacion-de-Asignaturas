<template>
    <main class="home-main">
        <div class="home-content">   
            <InfoSpec/>
        </div>
    </main>
</template>

<script setup lang="ts">
import InfoSpec from '@/features/home/InfoSpec.vue';
</script>

<style scoped lang="postcss">

.home-main {
  @apply px-10 h-screen relative ;  
}

.home-title {
  @apply text-5xl font-bold tracking-tight ; 
}

.home-content {
    @apply m-0 pt-10;
}

</style>