<template>
    <div  class=" flex justify-center flex-col">
        <RequestReviewCard
            class="max-w-[1500px]"
            v-for="convalidation in convalidations"
              :key="convalidation.id"
              :convalidation="convalidation"
        />
    </div>
  </template>
  
<script setup lang="ts">
  import RequestReviewCard from '@/modules/admin/requests/RequestReviewCard.vue';

  import type { ConvalidationResponse } from '@/interfaces/convalidation_model';
  import { useConvalidationsStore } from '@/stores/convalidation_store';
  import { ref, onMounted } from 'vue';

  import {ConvalidationStates} from '@/enums/convalidation_states';

  
  const convalidationsStore = useConvalidationsStore();

  const convalidations = ref<ConvalidationResponse[]>([]);

  async function getConvalidationHandler() {
    try {
        await convalidationsStore.getConvalidationsByStateStore(ConvalidationStates.ENVIADA);
        convalidations.value = convalidationsStore.allConvalidations;
    } 
    catch (error) {
        console.error('Error al obtener convalidaciones:', error);
    }
  }  


  
  
onMounted(getConvalidationHandler);
</script>