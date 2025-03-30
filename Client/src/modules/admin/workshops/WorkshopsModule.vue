<template>
  <main class="workshops-main">
    <WorkshopsCreation 
      :visible="isModalVisible"
      @close="isModalVisible = false"
    />

   
      <div class="flex justify-between border-b pb-5 mb-5">
        <h1 class="workshops-title">Talleres</h1> 
        <button @click="createModal" class="bg-primary rounded-lg border border-border px-5">Añadir taller</button>
      </div>
   
    <div class="workshops-content">
      <WorkshopsList /> 
    </div>
  </main>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import WorkshopsList from '@/modules/admin/workshops/WorkshopsList.vue';
import WorkshopsCreation from '@/modules/admin/workshops/WorkshopsCreation.vue';


const isModalVisible = ref(false);

const createModal = () => {
  isModalVisible.value = true;
};






</script>

<style scoped lang="postcss">
.workshops-main {
  @apply flex flex-col mx-5 px-10 mt-16 h-screen relative;
}

.workshops-title {
  @apply text-5xl text-foreground font-bold font-mono;
}

.workshops-content {
  @apply m-0 p-0;
}
</style>