<template>
  <div v-if="visible" class="fixed inset-0 bg-black bg-opacity-70 flex justify-center items-center">
    <div class="bg-background p-16 rounded-2xl shadow-lg w-2/3 flex flex-col space-y-8">
      <!-- Encabezado -->
      <div class="flex justify-between items-center">
        <div class="flex flex-col space-y-2">
          <h1 class="text-3xl font-bold">{{ workshop.name }}</h1>
          <p>Profesor: {{ workshop.professor }}</p>
          <p>Semestre: {{ workshop.year }}-{{ workshop.semester }}</p>
          <p>Fecha de Inicio: {{ formatReadableDate(workshop.initial_date) }}</p>
        </div>
        <div 
          class="tooltip group relative flex items-center justify-center cursor-pointer"
          @click="downloadWorkshopDetails"
        >
          <Icon icon="dashicons:pdf" class="text-7xl text-muted-foreground group-hover:text-foreground" />
          <span class="tooltip-text bg-card text-card-foreground text-sm rounded px-2 py-1 absolute bottom-full mb-2 hidden group-hover:flex">Descargar PDF</span>
        </div>
      </div>

      <!-- Tabla de Inscripciones -->
      <WorkshopsInscriptions :id_workshop="workshop.id" />

      <!-- Botón de Cerrar -->
      <div class="flex justify-end">
        <button 
          @click="close" 
          class="px-6 py-3 bg-destructive text-foreground rounded-lg hover:bg-destructive-hover"
        >
          Cerrar
        </button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { defineProps, defineEmits } from 'vue';
import type { WorkshopResponse } from '@/interfaces/workshop_model';
import formatReadableDate from '@/helpers/format_date';
import { Icon } from '@iconify/vue';
import WorkshopsInscriptions from './WorkshopsInscriptions.vue'; // Ruta relativa al componente de inscripciones

const props = defineProps<{
  workshop: WorkshopResponse;
  visible: boolean;
}>();

const emit = defineEmits(['close']);

// Método para cerrar el modal
const close = () => {
  emit('close');
};

// Método para descargar el archivo PDF
const downloadWorkshopDetails = () => {
  // Aquí se implementa la lógica para descargar el archivo PDF del taller
};
</script>

<style scoped>
.tooltip {
  position: relative;
}
.tooltip-text {
  display: none;
}
.group:hover .tooltip-text {
  display: flex;
}
</style>
