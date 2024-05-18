<template>
  <div  class=" flex justify-center flex-col max-w-screen-xl mx-auto p-10 m-10 rounded-lg">
      <AdminCard
          class="max-w-[1500px]"
          v-for="convalidation in convalidations"
          :key="convalidation.id"
          :convalidation="convalidation"
      />
  </div>
</template>


<script setup lang="ts">
    import AdminCard from '@/components/AdminCard.vue';
    import type {ConvalidationResponse} from '@/interfaces/convalidation_model';
    import { getAllConvalidations } from '@/services/convalidation_api';
    import { ref, onMounted} from 'vue';


    const convalidations = ref<ConvalidationResponse[]>([]);
       
    const getConvalidationsHandler =  
      (async () => {
          try {
            convalidations.value = await getAllConvalidations();
          } catch (error) {
            console.error('Error al obtener las convalidaciones:', error);
          } 
      });

    onMounted(getConvalidationsHandler);
    
</script>

