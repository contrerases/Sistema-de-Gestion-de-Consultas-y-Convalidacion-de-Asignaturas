<template>

    <HistoryDetailDialog 
    :isOpen="isDialogOpen" 
    :request="selectedRequest" 
    @close="isDialogOpen = false" 
  />
  
    <div class="flex justify-center flex-col">
      <!-- Spinner de carga -->
      <LoadingSpinner v-if="isLoading" />
  
      <template v-else>
        <!-- Mensaje cuando no hay solicitudes -->
        <div v-if="!isLoading && requests.length === 0" class="flex justify-center items-center h-[50vh] italic text-muted">
          <p class="text-2xl">No hay solicitudes</p>
        </div>
  
        <!-- Tabla cuando hay solicitudes -->
        <div v-else>
          <div class="overflow-x-auto bg-card text-foreground rounded-lg shadow-md">
            <table class="min-w-full table-auto border border-border">
              <thead>
                <tr>
                  <th class="py-3 px-4 text-left">ID</th>
                  <th class="py-3 px-4 text-left">Rol</th>
                  <th class="py-3 px-4 text-left">RUT</th>
                  <th class="py-3 px-4 text-left">Nombre Estudiante</th>
                  <th class="py-3 px-4 text-left">Fecha de creacion</th>
  
  
                </tr>
              </thead>
              <tbody>
                <tr v-for="request in requests" :key="request.id" class="hover:opacity-60 cursor-pointer"  @click="openDetailsDialog(request)">
                  <td class="py-3 px-4 border border-border">{{ request.id }}</td>
                  <td class="py-3 px-4 border border-border">{{ request.rol_student }}</td>
                  <td class="py-3 px-4 border border-border">{{ request.rut_student }}</td>
                  <td class="py-3 px-4 border border-border">{{ request.name_student }}</td>
                  <td class="py-3 px-4 border border-border">{{ formatReadableDate(request.creation_date) }}</td>
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
  
  import formatReadableDate from '@/helpers/format_date';
  
  import LoadingSpinner from '@/common/LoadingSpinner.vue';
  import { useRequestStore } from '@/stores/request_store';
  import { useAuthStore } from '@/stores/auth_store';
  
  
  import HistoryDetailDialog from '@/modules/admin/history/HistoryDetailDialog.vue';
  
  
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
      await request_store.getRequestByStudentRutStore(auth_store.rut);
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
  /* Estilos personalizados para la tabla */
  table {
    width: 100%;
    border-collapse: collapse;
  }
  
  th, td {
    text-align: left;
    padding: 0.75rem;
  }
  
  
  </style>