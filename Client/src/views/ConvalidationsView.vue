<template>
  <div  class=" flex justify-center flex-col max-w-screen-xl mx-auto p-10 m-10 rounded-lg">
      <RequestCard
          class="max-w-[1500px]"
          v-for="convalidation in convalidations"
          :key="convalidation.id"
          :convalidation="convalidation"
      />
  </div>
</template>


<script setup lang="ts">
    import RequestCard from '@/components/RequestCard.vue';
    import type {ConvalidationResponse} from '@/models/Convalidation';
    import { getAllConvalidation } from '@/resources/convalidation_api';
    import { ref, onMounted} from 'vue';


    const convalidations = ref<ConvalidationResponse[]>([]);
       
    const getConvalidationsHandler =  
      (async () => {
          try {
            convalidations.value = await getAllConvalidation();
          } catch (error) {
            console.error('Error al obtener las convalidaciones:', error);
          } 
      });

    onMounted(getConvalidationsHandler);
    
</script>

