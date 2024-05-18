<template>
    <div  class=" flex justify-center flex-col rounded-lg">
        <ConvalidationStudentCard
            class="max-w-[1500px]"
            v-for="convalidation in convalidations"
              :key="convalidation.id"
              :convalidation="convalidation"
        />
    </div>
  </template>
  
<script setup lang="ts">
  import ConvalidationStudentCard from '@/components/ConvalidationStudentCard.vue';
  import type { ConvalidationResponse } from '@/interfaces/convalidation_model';
  import { useConvalidationsStore } from '../stores/convalidation_store';
  import { ref, onMounted } from 'vue';

  async function getConvalidationHandler() {
    try {
        await convalidationsStore.getAllConvalidationsStore();
        convalidations.value = convalidationsStore.allConvalidations;
    } 
    catch (error) {
        console.error('Error al obtener convalidaciones:', error);
    }
  }  

  const convalidationsStore = useConvalidationsStore();

  const convalidations = ref<ConvalidationResponse[]>([]);

  
  
onMounted(getConvalidationHandler);
</script>