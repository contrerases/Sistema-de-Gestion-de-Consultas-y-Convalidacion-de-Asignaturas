<template>
    <div  class=" flex justify-center flex-col">
      <LoadingSpinner v-if="isLoading"/>
      <div v-if="request_convalidations.length === 0 && !isLoading" class="flex justify-center items-center h-[50vh] italic text-muted">
        <p class="text-2xl">No hay nuevas solicitudes</p>
      </div>
      <template v-else>
        <RequestReviewCard
        v-for="convalidation in request_convalidations"
          :key="convalidation.id"
          :convalidation="convalidation"
          @update-list="getConvalidationHandler"
    />
      </template>
    </div>
  </template>
  
<script setup lang="ts">
  import RequestReviewCard from '@/modules/admin/requests/RequestReviewCard.vue';

  import type { ConvalidationResponse } from '@/interfaces/convalidation_model';
  import { useRequestConvalidationsStore } from '@/stores/request_convalidation_store';
  import { ref, onMounted } from 'vue';
  import LoadingSpinner from '@/common/LoadingSpinner.vue';


  let isLoading = ref<boolean>(true);
  
  const request_convalidationsStore = useRequestConvalidationsStore();

  const request_convalidations = ref<ConvalidationResponse[]>([]);

  async function getConvalidationHandler() {
    try {
        await request_convalidationsStore.getAllRequestConvalidationsStore();
        request_convalidations.value = request_convalidationsStore.allRequestConvalidations;
    } 
    catch (error) {
        console.error('Error al obtener convalidaciones:', error);
    }
    finally {
        isLoading.value = false;
    }
  }  


  
  
onMounted(getConvalidationHandler);
</script>