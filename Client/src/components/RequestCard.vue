<script setup lang="ts">
import type { Convalidation } from '@/models/Convalidation';
import { ref } from 'vue';
import axios from 'axios';
import ConvalidationsView from '@/views/ConvalidationsView.vue';

const props = defineProps<{
  convalidation: Convalidation;
}>()

const showCard = ref(false);


function toggleCardShow() {
  console.log('props.convalidation:', props.convalidation);
  showCard.value = !showCard.value;
}

function formatReadableDate(date: string | null): string {
  const settings: Intl.DateTimeFormatOptions = {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  };
  return date ? new Date(date).toLocaleDateString('es-ES', settings) : '-';
}


function updateConvalidation() {  
  axios.put(`http://localhost:8000/convalidations/set_convalidation/${props.convalidation.id}`, props.convalidation )
  .then(response => {
    console.log('Convalidación actualizada correctamente:', response.data);
  })
  .catch(error => {
    console.error('Error al actualizar la convalidación:', error);
  });
}


</script>


<template>
  <main class="main flex flex-col">
    <div class="card-show grid grid-cols-3 gap-y-4 gap-x-10">
        <div class="item flex flex-col ">
          <div class="title">Rol Estudiante </div>
          <div class=" box border rounded-lg p-4">{{ convalidation.rol }} </div>
        </div>
        <div class="item flex flex-col">
          <div class="title">Nombre </div>
          <div class="box border rounded-lg p-4">Camilo Eugenio Contreras Espinoza</div>
        </div>
        <div class="item flex flex-col">
          <div class="title">ID </div>
          <div class="box border rounded-lg p-4">{{ convalidation.id }}</div>
        </div>
        <div class="item flex flex-col col-span-2">
          <div class="title">Asignatura a convalidar </div>
          <div class="box border rounded-lg p-4 ">{{ convalidation.id_origin_course }}</div>
        </div>
        <select v-model="convalidation.state"  class="text-black box border rounded-lg row-span-2 p-4 w-full h-full bg-input text-primary-foreground text-start">
          <option value="pending">En revisión</option>
          <option value="ap_jc">Aprobada por el Jefe de Carrera</option>
          <option value="ap_de">Aprobada por Direccion de estudio</option>
          <option value="approved">Aprobada</option>
          <option value="rejected">Rechazada</option>
        </select>
        
        <div class="item flex flex-col col-span-2">
          <div class="title">Asignatura cursada</div>
          <div class="box border rounded-lg p-4">{{ convalidation.id_destination_course }}</div>
        </div>
        <div class="item flex flex-col">
          <div class="title"> Fecha de creación solicitud </div>
          <div class="box border rounded-lg p-4">{{ formatReadableDate(convalidation.creation_date) }}</div>
        </div>
        <div class="item flex flex-col">
          <div class="title">Fecha de finalización </div>
          <div class="box border rounded-lg p-4">{{ convalidation.approval_date ? formatReadableDate(convalidation.approval_date
          ) : '-' }}</div>
        </div>
        <div class="item flex flex-col gap-y-2">
          <div class="title"></div>
          <button @click="toggleCardShow" class="box border rounded-lg p-4 text-center bg-primary flex items-center justify-center w-1/2 m-auto">
            {{ showCard ? 'Contraer' : 'Expandir' }}
          </button>
        </div>
    </div>
    <div class="border-t-2 mx-2 mt-4 pt-4 "></div>
    <div v-show="showCard" class="card-show  grid grid-cols-3 gap-y-4 gap-x-10">
      <div class="item flex flex-col row-span-2 col-span-2">
        <div class="title">Comentarios</div>
        <input v-model="convalidation.comments"  class=" box border rounded-lg p-4 w-full h-full text-start align-top">
      </div>
     <div class="item">
      <div class="title">Revisado por</div>
      <div class="box border rounded-lg p-4"> Pedro Godoy</div>
     </div>
     <div class="item">
      <div class="title">Tipo</div>
      <div class="box border rounded-lg p-4">Libre || Electivo</div>
     </div>
      <button @click="updateConvalidation" class="box border rounded-lg p-4 mt-4 bg-primary"> Revisar</button>
    
  </div>

    
    

  </main>

</template>


<style lang="postcss">
.box {
  @apply  font-mono  bg-input;

}

.item {
  @apply flex flex-col ;
}

.title {
  @apply text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70 pb-2;
}

.main {
  @apply flex justify-center max-w-screen-xl mx-auto p-10 m-10 rounded-lg border  bg-card;
}

.card-show{
  @apply w-full h-full shadow-sm  p-4 ;
}




.card-header {
  @apply flex flex-col gap-y-1.5 p-6;
}

.card-title {
  @apply text-2xl font-semibold leading-none tracking-tight;
}

.card-description {
  @apply text-sm text-slate-500 dark:text-slate-400
}

.card-content {
  @apply p-6 pt-0;
}

.card-footer {
  @apply flex items-center p-6 pt-0;
}
</style>