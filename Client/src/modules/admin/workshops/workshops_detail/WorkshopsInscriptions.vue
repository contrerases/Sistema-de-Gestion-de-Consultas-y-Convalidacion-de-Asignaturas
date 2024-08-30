<template>
    <main>
        <!-- title -->
        <div>
            <p class="text-3xl pb-5 font-bold">Inscripciones</p>
        </div>

        <div class="container">
            <div class="overflow-x-auto">
              <table class="table">
                <thead class="thead">
                  <tr class="tr-up">
                    <th class="th">RUT</th>
                    <th class="th">NOMBRE</th>
                    <th class="th">LIBRE A CONVALIDAR</th>
                  </tr>
                </thead>
                <tbody class="tbody">
                <div class="text-muted italic p-5" v-if="workshops_inscriptions.length === 0">No hay inscripciones</div>
                  <tr class="tr" v-for="inscription in workshops_inscriptions" >
                    <td class="td">{{ inscription.rut_student }}</td>
                    <td class="td">{{ inscription.name_student }}</td>
                    <td class="td">{{ inscription.curriculum_course }}</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
    </main>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';
import type { WorkshopsInscriptionsBase, WorkshopsInscriptionsPost, WorkshopsInscriptionsResponse } from '@/interfaces/workshop_inscription_model';
import {getWorkshopsInscriptionsByWorkshopId} from '@/services/workshop_inscriptions_api';


const props = defineProps<{
  id_workshop: number;
}>();


const workshops_inscriptions = ref<WorkshopsInscriptionsResponse[]>([]);

async function getWorkshopsInscriptionsByWorkshopIdHandler() : Promise<void> {
    try {
        
        workshops_inscriptions.value = await getWorkshopsInscriptionsByWorkshopId(props.id_workshop);
        console.log(workshops_inscriptions.value);
      
    } catch (error) {
        console.error(error);
    }
}

onMounted(getWorkshopsInscriptionsByWorkshopIdHandler);




</script>

<style scoped lang="postcss">
 .container {
   @apply w-full m-0 p-2 border border-border rounded-3xl; 
 }
 
 .table {
   @apply min-w-full bg-background; 
 }

 .tbody {
   @apply text-foreground text-sm font-light;
 }
 
 .thead {
   @apply bg-background text-foreground uppercase text-sm leading-normal border border-transparent;
 }
 
 .th {
   @apply py-3 px-6 text-left;
 }

 .td {
   @apply py-3 px-6 text-left whitespace-nowrap;
 }
 
 .tr {
   @apply border-b border-border; 
 }

 .tr-up {
   @apply border-b border-border; 
 }

 .tr:last-child {
   @apply border-b border-transparent; 
 }

 .icon {
   @apply text-foreground;
 }

 </style>
 