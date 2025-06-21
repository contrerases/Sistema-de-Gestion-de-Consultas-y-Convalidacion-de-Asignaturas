<template>


  <main>
    <div class="tabs-container">
      <!-- Botones de Tabs -->
      <div class="flex space-x-4 border-b border-border">
        <button
          :class="
            activeTab === 'tab1'
              ? 'border-b-2 border-primary text-primary'
              : 'text-muted-foreground'
          "
          class="px-4 py-2 font-semibold transition y"
          @click="activeTab = 'tab1'"
        >
          Talleres disponibles para inscripción
        </button>
        <button
          :class="
            activeTab === 'tab2'
              ? 'border-b-2 border-primary text-primary'
              : 'text-muted-foreground'
          "
          class="px-4 py-2 font-semibold transition"
          @click="activeTab = 'tab2'"
        >
          Talleres inscritos en curso
        </button>
        <button
          :class="
            activeTab === 'tab3'
              ? 'border-b-2 border-primary text-primary'
              : 'text-muted-foreground'
          "
          class="px-4 py-2 font-semibold transition"
          @click="activeTab = 'tab3'"
        >
          Talleres Cerrados
        </button>
      </div>

      <!-- Contenido de Tabs -->
      <div class="mt-4">
        <div v-if="activeTab === 'tab1'" class="p-4 rounded-md">
          <div class="pb-10">
            <div class="my-2 p-4 grid grid-cols-5 justify-start gap-3">
              <div class="col-span-2 text-xl font-bold uppercase border-b-4">
                Nombre del taller
              </div>
              <div class="text-xl font-bold uppercase border-b-4 pb-4">
                Profesor
              </div>
              <div class="text-xl font-bold uppercase border-b-4 pb-4">
                Semestre
              </div>
              <div class="text-xl font-bold uppercase border-b-4 pb-4">
                Fecha de Inicio
              </div>
            </div>

            <div
              v-for="workshop in availableWorkshops"
              :key="workshop.id"
              @click="selectWorkshop(workshop)"
             
            >
              <div
                class="border border-border [&>*]:uppercase rounded-lg my-2 p-4 grid grid-cols-5 gap-3 justify-start hover:border-primary hover:scale-105 transition hover:border-2 cursor-pointer shadow-lg"
                v-if="workshop.available"
              >
                <div class="col-span-2 border-r-2 border-border">
                  {{ workshop.name }}
                </div>
                <div class="border-r-2 border-border">
                  {{ workshop.professor }}
                </div>
                <div class="border-r-2 border-border">
                  {{ workshop.year }}-{{ workshop.semester }}
                </div>
                <div class="">
                  {{ formatReadableDate(workshop.initial_date) }}
                </div>
              </div>
            </div>
          </div>
        </div>
        <div v-if="activeTab === 'tab2'">
          <div
            v-for="workshop in inscriptionWorkshops"
            :key="workshop.id"
            @click="selectWorkshop(workshop)"
            class="[&>*]:hover:scale-105"
          >
            <div
              class="border border-border rounded-lg my-2 p-4 [&>*]:uppercase grid   grid-cols-5 gap-3 justify-start hover:border-primary hover:border-2 cursor-pointer shadow-lg"
            >
              <div class="col-span-2 border-r-2 border-border">
                {{ workshop.name }}
              </div>
              <div class="border-r-2 border-border">
                {{ workshop.professor }}
              </div>
              <div class="border-r-2 border-border">
                {{ workshop.year }}-{{ workshop.semester }}
              </div>
              <div class="">
                {{ formatReadableDate(workshop.initial_date) }}
              </div>
            </div>
          </div>
        </div>
        <div v-if="activeTab === 'tab3'" class="p-4 rounded-md">
          <!-- Lista de Workshops No Disponibles -->
          <div
            v-for="workshop in closedWorkshops"
            :key="workshop.id"
            @click="selectWorkshop(workshop)"
             class="[&>*]:hover:scale-105"
          >
            <div
              class="border border-border rounded-lg my-2 p-4 grid grid-cols-5 [&>*]:uppercase gap-3 justify-start hover:border-primary hover:border-2 cursor-pointer shadow-lg"
            >
              <div class="col-span-2 border-r-2 border-border">
                {{ workshop.name }}
              </div>
              <div class="border-r-2 border-border">
                {{ workshop.professor }}
              </div>
              <div class="border-r-2 border-border">
                {{ workshop.year }}-{{ workshop.semester }}
              </div>
              <div class="">
                {{ formatReadableDate(workshop.initial_date) }}
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Modal de Detalles del Workshop -->
    <WorkshopsDetail
      :workshop="selectedWorkshop"
      :visible="isModalVisible"
      @close="closeModal"
    />
  </main>
</template>
  
  <script setup lang="ts">
  import { ref, onMounted } from 'vue';
  import type { WorkshopResponse } from '@/interfaces/workshop_model';

  import { useAuthStore } from '@/shared/stores/auth_store';

  import WorkshopsDetail from "@/features/workshops/WorkshopsDetail.vue";

 
 

  import {getAvailableWorkshopsNotEnrolledByStudent, getCompletedWorkshopsByStudent, getEnrolledAvailableWorkshopsByStudent} from '@/shared/services/api/workshop_api';

  import formatReadableDate from '@/shared/helpers/format_date';


  const auth_store = useAuthStore();

const availableWorkshops = ref<WorkshopResponse[]>([]);
const inscriptionWorkshops = ref<WorkshopResponse[]>([]);
const completedWorkshops = ref<WorkshopResponse[]>([]);



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
        inscriptionWorkshops.value = await getEnrolledAvailableWorkshopsByStudent(auth_store.id);
        console.log('inscriopcion:' , inscriptionWorkshops.value);
    } catch (error) {
      console.error(error);
    }
}

onMounted(getAvailableWorkshopsHandler);
onMounted(getCompletedWorkshopsHandler);
onMounted(getEnrolledWorkshopsHandler);

const activeTab = ref("tab1");


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
  