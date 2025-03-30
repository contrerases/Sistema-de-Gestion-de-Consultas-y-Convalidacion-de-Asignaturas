<template>

    <RequestDetailsDialog   
      :isOpen="isDialogOpen" 
      :request="selected_request" 
      @close="closeDialog"
      @update-list="getRequestsHandler"
      />

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
              <thead class="border-b  border-border">
                <tr>
                  <th class="py-3 px-4 text-left">ID</th>
                  <th class="py-3 px-4 text-left">ROL</th>
                  <th class="py-3 px-4 text-left">RUT</th>
                  <th class="py-3 px-4 text-left">Nombre Estudiante</th>
                  <th class="py-3 px-4 text-left">Fecha de solicitud</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="request in requests" :key="request.id" class="hover:opacity-60 cursor-pointer " @click="openDetailsDialog(request)"
                  >
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
  import { ref, onMounted } from 'vue';

  import type { Request, RequestInsert, RequestResponse, RequestUpdate } from '@/interfaces/request_model';

  import formatReadableDate from '@/helpers/format_date';

  
  import LoadingSpinner from '@/common/LoadingSpinner.vue';

  import RequestDetailsDialog from '@/modules/admin/requests/RequestDetailsDialog.vue';


  import { useRequestStore } from '@/stores/request_store';
  
  



  let isLoading = ref<boolean>(true);
  
  const request_store = useRequestStore();

  const requests = ref<RequestResponse[]>([]);

  const selected_request = ref({} as RequestResponse); 

  const isDialogOpen = ref<boolean>(false);


  async function getRequestsHandler()  {
    isLoading.value = true;
    try {
        await request_store.getSendRequestsStore();
        requests.value = request_store.allSendRequests;
        console.log('Convalidaciones:', requests.value);
    } 
    catch (error) {
        console.error('Error al obtener convalidaciones:', error);
    }
    finally {
        isLoading.value = false;
    }
  }  


  function openDetailsDialog(request: RequestResponse) {
    selected_request.value = request;
    isDialogOpen.value = true;
  }

  function closeDialog() {
    isDialogOpen.value = false;
  }

  
  
  
onMounted(getRequestsHandler);
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