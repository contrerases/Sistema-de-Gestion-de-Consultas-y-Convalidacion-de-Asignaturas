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
          Talleres para inscripcion
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
          Talleres en curso
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
            v-for="workshop in currentWorkshops"
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
import { ref, onMounted } from "vue";
import type { WorkshopResponse } from "@/interfaces/workshop_model";
import WorkshopsDetail from "../../modules/admin/workshops/workshops_detail/WorkshopsDetail.vue";

import { getWorkshopsAvailable } from "@/shared/services/api/workshop_api";
import formatReadableDate from "@/shared/helpers/format_date";




const availableWorkshops = ref<WorkshopResponse[]>([]);

const inscriptionWorkshops = ref<WorkshopResponse[]>([]);
const currentWorkshops = ref<WorkshopResponse[]>([]);
const closedWorkshops = ref<WorkshopResponse[]>([]);

async function getAvailableWorkshopsHandler(): Promise<void> {
  try {
    availableWorkshops.value = await getWorkshopsAvailable(true);
    getCurrentWorkshops();
    console.log(availableWorkshops.value);
  } catch (error) {
    console.error(error);
  }
}

async function getUnavailableWorkshopsHandler(): Promise<void> {
  try {
    closedWorkshops.value = await getWorkshopsAvailable(false);
    console.log(closedWorkshops.value);
  } catch (error) {
    console.error(error);
  }
}

function getCurrentWorkshops() {
  const currentYear = new Date().getFullYear();
  const currentSemester = new Date().getMonth() < 6 ? 1 : 2;

  currentWorkshops.value = availableWorkshops.value.filter(
    (workshop) =>
      workshop.year === currentYear && workshop.semester === String(currentSemester)
  );

  console.log(currentWorkshops.value);
}

function getInscriptionWorkshops() {
  const now = new Date();

  return availableWorkshops.filter(workshop => new Date(workshop.inscription_deadline) < now);
}
  console.log(inscriptionWorkshops.value);


onMounted(getAvailableWorkshopsHandler);
onMounted(getUnavailableWorkshopsHandler);

const emptyWorkshop: WorkshopResponse = {
  id: 0,
  name: "",
  semester: "1",
  year: 0,
  professor: "",
  initial_date: "",
  inscription_deadline: "",
  file_data: null,
  available: false,
  state: "",
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

const activeTab = ref("tab1");
</script>

<style scoped lang="postcss">
/* Tus estilos */
</style>
