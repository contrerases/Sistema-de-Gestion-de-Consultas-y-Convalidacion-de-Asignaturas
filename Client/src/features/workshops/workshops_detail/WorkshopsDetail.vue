<template>
  <div v-if="visible" class="fixed inset-0 bg-black bg-opacity-70 flex justify-center items-center">
    <div class="bg-background p-16 py-8 rounded-2xl shadow-lg w-2/3 flex flex-col ">
      <h1 class="text-5xl font-bold text-primary border-border border-b w-full pb-8 mb-8">{{ workshop.name }}</h1>
      <div class="flex justify-between items-center shadow-sm ">
      
        <!-- Información del Taller -->
        <div class="flex flex-col space-y-2 mb-8">
      
          <p class="text-muted-foreground">
            <span class="font-semibold text-card-foreground">Profesor:</span> {{ workshop.professor }}
          </p>
          <p class="text-muted-foreground">
            <span class="font-semibold text-card-foreground">Semestre:</span> {{ workshop.year }}-{{ workshop.semester }}
          </p>
          <p class="text-muted-foreground">
            <span class="font-semibold text-card-foreground">Fecha de Inicio:</span> {{ formatReadableDate(workshop.initial_date) }}
          </p>
        
          <p class="text-muted-foreground">
            <span class="font-semibold text-card-foreground">Fecha de Inscripcion:</span> {{ formatReadableDate(workshop.inscription_date) }}
          </p>
          <p class="text-muted-foreground">
            <span class="font-semibold text-card-foreground">Sala:</span> {{ formatReadableDate(workshop.inscription_date) }}
          </p>
          
          <p class="text-muted-foreground">
            <span class="font-semibold text-card-foreground">Bloque</span> {{ formatReadableDate(workshop.inscription_date) }}
          </p>
        </div>

        
     
      
        <!-- Botón de Descargar Syllabus -->
        <div
          class="tooltip group relative flex flex-col items-center justify-center cursor-pointer border border-border rounded-lg p-6 bg-muted hover:bg-muted/80 transition"
          @click="downloadWorkshopDetails"
        >
          <Icon icon="dashicons:pdf" class="text-5xl text-muted-foreground group-hover:text-primary transition" />
          <span class="tooltip-text bg-card text-card-foreground text-xs rounded px-3 py-1 absolute bottom-full mb-2 hidden group-hover:flex">
            Descargar Syllabus
          </span>
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
import formatReadableDate from '@/shared/helpers/format_date';
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
