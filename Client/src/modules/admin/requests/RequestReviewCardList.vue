<template>
    <div  class=" flex justify-center flex-col">
      <LoadingSpinner v-if="isLoading"/>
      <div v-if="requests.length === 0 && !isLoading" class="flex justify-center items-center h-[50vh] italic text-muted">
        <p class="text-2xl">No hay nuevas solicitudes</p>
      </div>
      <template v-else>
        <RequestReviewCard
          v-for="request in requests"
          :key="request.id"
          :request="request"
          @update-list="getConvalidationHandler"
    />
      </template>
    </div>
  </template>
  
<script setup lang="ts">
  import { ref, onMounted } from 'vue';

  import type { Request, RequestInsert, RequestResponse, RequestUpdate } from '@/interfaces/request_model';

  import RequestReviewCard from '@/modules/admin/requests/RequestReviewCard.vue';
  import LoadingSpinner from '@/common/LoadingSpinner.vue';


  import { useRequestStore } from '@/stores/request_convalidation_store';
  



  let isLoading = ref<boolean>(true);
  
  const request_store = useRequestStore();

  const requests = ref<RequestResponse[]>([]);

  async function getConvalidationHandler()  {
    try {
        await request_store.getSendRequestsStore();
        requests.value = request_store.allSendRequests;
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