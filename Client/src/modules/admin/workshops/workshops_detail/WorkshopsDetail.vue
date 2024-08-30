<template>
  <div v-if="visible" class="fixed inset-0 bg-black bg-opacity-50 flex justify-center items-center">
    <div class="bg-background p-20 rounded-lg shadow-lg w-2/3  flex flex-col justify-between">

      <div class="flex flex-row justify-between pb-10">

        <div class="workshop-description flex flex-col gap-2">
          <h1 class="text-3xl font-bold">
            {{ workshop.name }}
          </h1>
          <h2>
            Profesor: {{ workshop.professor }}
          </h2>
          <p>
            Semestre: {{ workshop.year }}-{{ workshop.semester }}
          </p>
          <p>
            Fecha de Inicio: {{ formatReadableDate(workshop.initial_date) }}
          </p>
        </div>

        <div
          class="bg-background border border-border rounded-lg bg-opacity-55 w-36 flex items-center align-middle justify-center hover:border-primary cursor-pointer">
          <Icon class="text-foreground text-7xl" icon="dashicons:pdf" />
        </div>
      </div>

      <WorkshopsInscriptions :id_workshop="props.workshop.id"/>

      <div class="mt-4 flex justify-end">
        <button @click="close"
          class="bg-destructive text-white px-4 py-2 rounded hover:bg-destructive-hover">Close</button>
      </div>

    </div>
  </div>
</template>

<script setup lang="ts">
import { defineProps, defineEmits } from 'vue';
import type { WorkshopResponse } from '@/interfaces/workshop_model';
import formatReadableDate from '@/helpers/format_date';
import { Icon } from '@iconify/vue/dist/iconify.js';
import WorkshopsInscriptions from '@/modules/admin/workshops/workshops_detail/WorkshopsInscriptions.vue';

const props = defineProps<{
  workshop: WorkshopResponse;
  visible: boolean;
}>();

const emit = defineEmits(['close']);

// Método para cerrar el modal
const close = () => {
  emit('close');
};

</script>

<style scoped>
/* Estilos adicionales para el modal */
</style>