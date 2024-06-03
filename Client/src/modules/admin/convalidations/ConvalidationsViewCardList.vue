<template>
  <div class="flex justify-center flex-col">
    <LoadingSpinner v-if="isLoading"/>
    <template v-else>
      <div v-if="convalidations.length === 0 && !isLoading" class="flex justify-center items-center h-[50vh] italic text-muted">
        <p class="text-2xl">No hay nuevas solicitudes</p>
      </div>
      <ConvalidationViewCard
        class="max-w-[1500px]"
        v-for="convalidation in convalidations"
        :key="convalidation.id"
        :convalidation="convalidation"
      />
    </template>
  </div>
</template>

<script setup lang="ts">
import ConvalidationViewCard from '@/modules/admin/convalidations/ConvalidationViewCard.vue';
import LoadingSpinner from '@/common/LoadingSpinner.vue'; 

import type { ConvalidationResponse } from '@/interfaces/convalidation_model';
import { useConvalidationsStore } from '@/stores/convalidation_store';
import { ref, onMounted } from 'vue';

const isLoading = ref<boolean>(true);

const convalidationsStore = useConvalidationsStore();

const convalidations = ref<ConvalidationResponse[]>([]);


async function getConvalidationHandler() {
  try {
    await convalidationsStore.getAllConvalidationsStore();
    convalidations.value = convalidationsStore.allConvalidations;
  } catch (error) {
    console.error('Error al obtener convalidaciones:', error);
  } finally {
    isLoading.value = false;

  }
}  

onMounted(getConvalidationHandler);
</script>
