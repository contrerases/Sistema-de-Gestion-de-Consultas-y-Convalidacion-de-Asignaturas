<template>
    <main class="new_request-main">
        <h1 class="new_request-title">Nueva Solicitud de Convalidación</h1>
        <div class="new_request-content">   
            <NewRequestForm/>
        </div>
    </main>
</template>

<script setup lang="ts">
import NewRequestForm from '@/features/convalidations/requests/components/NewRequestForm.vue';
</script>

<style scoped lang="postcss">

.new_request-main {
  @apply flex flex-col mx-5 px-10 mt-16 h-screen relative ;  
}

.new_request-title {
  @apply text-5xl font-bold tracking-tight ; 
}

.new_request-content {
    @apply m-0 pt-10;
}

</style>