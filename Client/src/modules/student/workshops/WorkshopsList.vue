<template>

   

    <main>
      <WorkshopsInscriptionsForm
        :visible="isModalVisible"
        :workshop="selectedWorkshop"
        @close="closeModal"
      />
      <div class="pb-10">
        <h1 class="text-2xl font-bold pb-5">Talleres Disponibles</h1>
        <div v-if="availableWorkshops.length === 0">
            <p class="text-muted italic">No hay talleres disponible</p>
        </div>
        <div v-for="workshop in availableWorkshops" :key="workshop.id" @click="selectWorkshop(workshop)">
          <div class="border border-border rounded-lg my-2 p-4 grid grid-cols-5 justify-start hover:border-primary cursor-pointer">
            <div class="col-span-2">{{ workshop.name }}</div>
            <div>{{workshop.professor}}</div>
            <div>{{ workshop.year }}-{{ workshop.semester }}</div>
            <div>{{ formatReadableDate(workshop.initial_date)}}</div>
          </div>
        </div>
      </div>

      <div class="pb-10">
        <h1 class="text-2xl font-bold pb-5">Talleres en curso</h1>
        <div v-for="workshop in enrolledWorkshops" :key="workshop.id">
          <div class="border border-border rounded-lg my-2 p-4 grid grid-cols-5 justify-start ">
            <div class="col-span-2">{{ workshop.name }}</div>
            <div>{{workshop.professor}}</div>
            <div>{{ workshop.year }}-{{ workshop.semester }}</div>
            <div>{{ formatReadableDate(workshop.initial_date)}}</div>
          </div>
        </div>
      </div>

      <div class="pb-10">
        <h1 class="text-2xl font-bold pb-5">Talleres cursados</h1>
        <div v-for="workshop in completedWorkshops" :key="workshop.id">
          <div class="border border-border rounded-lg my-2 p-4 grid grid-cols-5 justify-start">
            <div class="col-span-2">{{ workshop.name }}</div>
            <div>{{workshop.professor}}</div>
            <div>{{ workshop.year }}-{{ workshop.semester }}</div>
            <div>{{ formatReadableDate(workshop.initial_date)}}</div>
          </div>
        </div>
      </div>
  
      
     
    </main>
  </template>
  
  <script setup lang="ts">
  import { ref, onMounted } from 'vue';
  import type { WorkshopResponse } from '@/interfaces/workshop_model';

  import { useAuthStore } from '@/stores/auth_store';


 
 

  import {getAvailableWorkshopsNotEnrolledByStudent, getCompletedWorkshopsByStudent, getEnrolledAvailableWorkshopsByStudent} from '@/services/workshop_api';
  import WorkshopsInscriptionsForm from '@/modules/student/workshops/WorkshopsInscriptionForm.vue';
  import formatReadableDate from '@/helpers/format_date';


  const auth_store = useAuthStore();

const availableWorkshops = ref<WorkshopResponse[]>([]);
const completedWorkshops = ref<WorkshopResponse[]>([]);
const enrolledWorkshops = ref<WorkshopResponse[]>([]);


async function getAvailableWorkshopsHandler(): Promise<void> {
    try {
        availableWorkshops.value = await getAvailableWorkshopsNotEnrolledByStudent(auth_store.id);
        console.log(availableWorkshops.value);
    } catch (error) {
      console.error(error);
    }
}

async function getCompletedWorkshopsHandler(): Promise<void> {
    try {
        completedWorkshops.value = await getCompletedWorkshopsByStudent(auth_store.id);
        console.log(completedWorkshops.value);
    } catch (error) {
      console.error(error);
    }
}

async function getEnrolledWorkshopsHandler(): Promise<void> {
    try {
        enrolledWorkshops.value = await getEnrolledAvailableWorkshopsByStudent(auth_store.id);
        console.log(enrolledWorkshops.value);
    } catch (error) {
      console.error(error);
    }
}

onMounted(getAvailableWorkshopsHandler);
onMounted(getCompletedWorkshopsHandler);
onMounted(getEnrolledWorkshopsHandler);




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
  
  
  const isModalVisible = ref(false);
  const selectedWorkshop = ref<WorkshopResponse>(emptyWorkshop);
  

  const selectWorkshop = (workshop: WorkshopResponse) => {
    selectedWorkshop.value = workshop;
    isModalVisible.value = true;
    
  };

  const closeModal = () => {
    isModalVisible.value = false;
    selectedWorkshop.value = emptyWorkshop;
  };

  
  
  </script>
  
  <style scoped lang="postcss">
  
  </style>
  