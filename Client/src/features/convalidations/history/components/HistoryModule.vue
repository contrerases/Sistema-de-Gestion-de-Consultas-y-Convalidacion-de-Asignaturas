<template>

    <HistoryFiltersDialog
    :isOpen="showFiltersModal"
    @close="toggleFiltersModal"
    @applyFilters="applyFilters"
  />


    <main class="history-main">
      <div class="flex justify-between border-b pb-5 mb-5">
        <h1 class="history-title">Historial de solicitudes</h1>
        <button @click="toggleFiltersModal" class="bg-primary rounded-lg border border-border px-5">
          Filtros de búsqueda
        </button>
      </div>
        <div class="history-content">
            <HistoryViewCardList 
              :filters="filters"
            />
        </div>
    </main>
</template>

<script setup lang="ts">

import HistoryViewCardList from '@/features/convalidations/history/components/HistoryViewCardList.vue';
import HistoryFiltersDialog from '@/features/convalidations/history/components/HistoryFiltersDialog.vue';

import type { RequestFiltered } from '@/shared/types/request_model';

import { ref } from 'vue';

const showFiltersModal = ref<boolean>(false);

const filters = ref<RequestFiltered>({
  name_student: '',
  rut_student: '',
  rol_student: '',
  date_lower_bound: null,
  date_upper_bound: null,
});

function toggleFiltersModal(): void {
  showFiltersModal.value = !showFiltersModal.value;
}

function applyFilters(final_filters: RequestFiltered): void {
  filters.value = final_filters;
  toggleFiltersModal();
}















</script>

<style scoped lang="postcss">

.history-main {
  @apply flex flex-col mx-5 px-10 mt-16 h-screen relative ;  
}

.history-title {
  @apply text-5xl font-bold tracking-tight; 
}

.history-content {
    @apply m-0 p-0;
}

</style>