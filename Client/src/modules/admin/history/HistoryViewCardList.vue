<template>
  <div class="flex justify-center flex-col">
    <LoadingSpinner v-if="isLoading"/>
    <template v-else>
      <div v-if="requests.length === 0 && !isLoading" class="flex justify-center items-center h-[50vh] italic text-muted">
        <p class="text-2xl">...</p>
      </div>
      <HistoryViewCard
        class="max-w-[1500px]"
        v-for="request in requests"
        :key="request.id"
        :convalidation="request"
      />
    </template>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';


import type { Request, RequestInsert, RequestResponse } from '@/interfaces/request_model';

import HistoryViewCard from '@/modules/admin/history/HistoryViewCard.vue';
import LoadingSpinner from '@/common/LoadingSpinner.vue'; 

import { useRequestStore } from '@/stores/request_store';


const isLoading = ref<boolean>(false);

const request_store = useRequestStore();

const requests = ref<RequestResponse[]>([]);

const id = ref<number | null>(null);
const rol = ref<string | null>(null);
const rut = ref<string |null>(null);
const initial_date = ref<string | null>(null);
const final_date = ref<string | null>(null);



async function getRequestByIDStoreHandler() {
  try {
    if (id.value) {
      await request_store.getRequestByIDStore(id.value);
      requests.value = request_store.filterRequests;
    }

  } catch (error) {
    console.error('Error al obtener convalidaciones:', error);
  } finally {
    isLoading.value = false;
  }
}  

async function getRequestByRolStoreHandler() {
  try {
    if (rol.value) {
      await request_store.getRequestsByStudentRolStore(rol.value);
      requests.value = request_store.filterRequests;
    }

  } catch (error) {
    console.error('Error al obtener convalidaciones:', error);
  } finally {
    isLoading.value = false;
  }
}

async function getRequestByRutStoreHandler() {
  try {
    if (rut.value) {
      await request_store.getRequestByStudentRutStore(rut.value);
      requests.value = request_store.filterRequests;
    }

  } catch (error) {
    console.error('Error al obtener convalidaciones:', error);
  } finally {
    isLoading.value = false;
  }
}

async function getRequestByDateStoreHandler() {
  try {
    if (initial_date.value && final_date.value) {
      await request_store.getRequestsByDateRangeStore(initial_date.value, final_date.value);
      requests.value = request_store.filterRequests;
    }

  } catch (error) {
    console.error('Error al obtener convalidaciones:', error);
  } finally {
    isLoading.value = false;
  }
}

</script>
