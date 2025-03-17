<template>
  <main>

    <div class="pb-10">
      <h1 class="text-2xl font-bold pb-5">Talleres Actuales</h1>
      <div v-for="workshop in availableWorkshops" :key="workshop.id" @click="selectWorkshop(workshop)">
        <div
          class="border border-border rounded-lg my-2 p-4 grid grid-cols-5 justify-start hover:border-primary cursor-pointer">
          <div class="col-span-2">{{ workshop.name }}</div>
          <div>{{ workshop.professor }}</div>
          <div>{{ workshop.year }}-{{ workshop.semester }}</div>
          <div>{{ formatReadableDate(workshop.initial_date) }}</div>
        </div>
      </div>
    </div>

    <!-- Lista de Workshops No Disponibles -->
    <div>
      <h1 class="text-2xl font-bold pb-5">Talleres Pasados</h1>
      <div v-for="workshop in unavailableWorkshops" :key="workshop.id" @click="selectWorkshop(workshop)">
        <div
semest    class="border border-border rounded-lg my-2 p-4 grid grid-cols-5 justify-start hover:border-primary cursor-pointer">
          <div class="col-span-2">{{ workshop.name }}</div>
          <div>{{ workshop.professor }}</div>
          <div>{{ workshop.year }}-{{ workshop.semester }}</div>
          <div>{{ formatReadableDate(workshop.initial_date) }}</div>
        </div>
      </div>
    </div>

    <!-- Modal de Detalles del Workshop -->
    <WorkshopsDetail :workshop="selectedWorkshop" :visible="isModalVisible" @close="closeModal" />
  </main>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';
import type { WorkshopResponse } from '@/interfaces/workshop_model';
import WorkshopsDetail from './workshops_detail/WorkshopsDetail.vue';


import { getWorkshopsAvailable } from '@/services/workshop_api';
import formatReadableDate from '@/helpers/format_date';



const availableWorkshops = ref<WorkshopResponse[]>([]);
const unavailableWorkshops = ref<WorkshopResponse[]>([]);


async function getAvailableWorkshopsHandler(): Promise<void> {
  try {
    availableWorkshops.value = await getWorkshopsAvailable(true);
    console.log(availableWorkshops.value);
  } catch (error) {
    console.error(error);
  }
}

async function getUnavailableWorkshopsHandler(): Promise<void> {
  try {
    unavailableWorkshops.value = await getWorkshopsAvailable(false);
    console.log(unavailableWorkshops.value);
  } catch (error) {
    console.error(error);
  }
}

onMounted(getAvailableWorkshopsHandler);
onMounted(getUnavailableWorkshopsHandler);


const emptyWorkshop: WorkshopResponse = {
  id: 0,
  name: '',
  semester: '',
  year: 0,
  professor: '',
  initial_date: '',
  file_data: null,
  available: false
};




// Estado para el modal
const isModalVisible = ref(false);
const selectedWorkshop = ref<WorkshopResponse>(emptyWorkshop);





// Método para seleccionar un workshop y abrir el modal
const selectWorkshop = (workshop: WorkshopResponse) => {
  selectedWorkshop.value = workshop;
  isModalVisible.value = true;
};

// Método para cerrar el modal
const closeModal = () => {
  isModalVisible.value = false;
  selectedWorkshop.value = emptyWorkshop;
};
</script>

<style scoped lang="postcss">
/* Tus estilos */
</style>