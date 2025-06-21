<template>

  <HistoryDetailDialog :isOpen="isDialogOpen" :request="selectedRequest" @close="isDialogOpen = false" />

  <div class="flex justify-center flex-col">

    <LoadingSpinner v-if="isLoading" />

    <template v-else>

      <div v-if="!isLoading && requests.length === 0"
        class="flex justify-center items-center h-[50vh] italic text-muted">
        <p class="text-2xl">No hay solicitudes</p>
      </div>


      <div v-else>
        <div class="overflow-hidden rounded-lg bg-card text-foreground shadow-md border border-border">
          <table class="min-w-full table-auto">
            <thead class="border border-border">
              <tr>
                <th class="py-3 px-4 text-left">ID</th>
                <th class="py-3 px-4 text-left">Rol</th>
                <th class="py-3 px-4 text-left">RUT</th>
                <th class="py-3 px-4 text-left">Nombre Estudiante</th>
                <th class="py-3 px-4 text-left">Fecha de solicitud</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="request in requests" :key="request.id" class="hover:opacity-60 cursor-pointer"
                @click="openDetailsDialog(request)">
                <td class="py-3 px-4 ">{{ request.id }}</td>
                <td class="py-3 px-4 ">{{ request.rol_student }}</td>
                <td class="py-3 px-4 ">{{ request.rut_student }}</td>
                <td class="py-3 px-4 ">{{ request.name_student }}</td>
                <td class="py-3 px-4 ">{{ formatReadableDate(request.creation_date) }}</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </template>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, watch } from 'vue';
import type { RequestFiltered, RequestResponse } from '@/interfaces/request_model';

import formatReadableDate from '@/shared/helpers/format_date';

import LoadingSpinner from '@/shared/components/load/LoadingSpinner.vue';
import { useRequestStore } from '@/shared/stores/request_store';
import { useAuthStore } from '@/shared/stores/auth_store';


import HistoryDetailDialog from '@/features/convalidations/history/components/HistoryDetailDialog.vue'; 

// MOVER A COMMON HISOTY DETAIL DIALOG


let isLoading = ref<boolean>(true);
const request_store = useRequestStore();
const auth_store = useAuthStore();
const requests = ref<RequestResponse[]>([]);

const isDialogOpen = ref(false); // Controla el estado del modal
const selectedRequest = ref(
  {} as RequestResponse
);


function openDetailsDialog(request: RequestResponse) {
  selectedRequest.value = request;
  isDialogOpen.value = true;
}


// Función para obtener las solicitudes filtradas
async function getRequestsHandler() {
  try {
    isLoading.value = true; // Mostrar el spinner mientras carga
    await request_store.getRequestByStudentRutStore(auth_store.rut as string);
    requests.value = request_store.requests;
    console.log('requests:', requests.value);
  } catch (error) {
    console.error('Error al obtener solicitudes:', error);
  } finally {
    isLoading.value = false; // Ocultar el spinner cuando termine
  }
}

onMounted(() => {
  getRequestsHandler();
});



</script>

<style scoped>
table {
  width: 100%;
  border-collapse: collapse;
}

th,
td {
  text-align: left;
  padding: 0.75rem;
}
</style>