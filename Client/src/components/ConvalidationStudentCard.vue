<script setup lang="ts">
import type { ConvalidationResponse } from '@/interfaces/convalidation_model';
import { formatReadableDate } from '@/interfaces/convalidation_model';
import { ref } from 'vue';

const props = defineProps<{
  convalidation: ConvalidationResponse;
}>()

const showCard = ref(false);

function toggleCardShow() {
  showCard.value = !showCard.value;

}


function downloadPdf(binaryPDF: string | null) {
  if (!binaryPDF) return;
  const binaryData = atob(binaryPDF);
  const bytes = new Uint8Array(binaryData.length);
  for (let i = 0; i < binaryData.length; i++) {
    bytes[i] = binaryData.charCodeAt(i);
  }
  const blob = new Blob([bytes], { type: 'application/pdf' });
  const pdfUrl = URL.createObjectURL(blob);
  const anchor = document.createElement('a');
  anchor.href = pdfUrl;
  anchor.target = '_blank';
  anchor.setAttribute('Descargar', 'file');
  document.body.appendChild(anchor);
  anchor.click();
  document.body.removeChild(anchor);
}

</script>


<template>
  <main class="main">
    <div class="p-10">
      <div class="card-show">
        <div class="item">
          <div class="title">Rol Estudiante </div>
          <div class="box"> {{ props.convalidation.student_rol }} </div>
        </div>
        <div class="item">
          <div class="title">Nombre </div>
          <div class="box"> {{ props.convalidation.student_name }} </div>
        </div>
        <div class="item">
          <div class="title">ID </div>
          <div class="box">{{ props.convalidation.id }}</div>
        </div>
        <div class="item col-span-2">
          <div class="title">Asignatura a convalidar </div>
          <div class="box">{{ props.convalidation.curriculum_course }}</div>
        </div>

        <div class="item">
          <div class="title">Estado</div>
          <div class="box" 
            :class="{
            'border-green-500': props.convalidation.state === 'Aprobada por DI' || props.convalidation.state === 'Aprobada por DE',
            'border-red-500': props.convalidation.state === 'Rechazada',
            'border-yellow-500': props.convalidation.state === 'Enviada'
          }">{{ props.convalidation.state }}</div>
        </div>

        <div v-if="props.convalidation.subject !== null" class="item col-span-2">
          <div class="title">Asignatura cursada</div>
          <div class="box">{{ props.convalidation.subject }}</div>
        </div>

        <div v-if="props.convalidation.workshop !== null" class="item col-span-2">
          <div class="title">Taller cursado</div>
          <div class="box">{{ props.convalidation.workshop }}</div>
        </div>
        <div v-if="props.convalidation.certified_course_name !== null" class="item flex flex-col col-span-2">
          <div class="title">Curso certificado cursado</div>
          <div class="box">{{ props.convalidation.certified_course_name }}</div>
        </div>
        <div v-if="props.convalidation.personal_project_name !== null" class="item flex flex-col col-span-2">
          <div class="title">Proyecto personal cursado</div>
          <div class="box">{{ props.convalidation.personal_project_name }}</div>
        </div>

        <div class="item">
          <div class="title">Tipo</div>
          <div class="box"> {{ props.convalidation.convalidation_type }}</div>
        </div>
        <div class="item">
          <div class="title"> Fecha de creación solicitud </div>
          <div class="box">{{ formatReadableDate(props.convalidation.creation_date) }}</div>
        </div>
        <div class="item">
          <div class="title">Fecha de finalización </div>
          <div class="box">{{ props.convalidation.revision_date ? formatReadableDate(props.convalidation.revision_date) : '-' }}</div>
        </div>
        <div
          v-if="props.convalidation.convalidation_type == 'Curso Certificado' || props.convalidation.convalidation_type == 'Proyecto Personal'"
          class="item">
          <div class="title">Archivo</div>
          <div class="box">
            <div>📁</div>
            <button @click="downloadPdf(props.convalidation.file_data)">{{ props.convalidation.file_name }}</button>
          </div>
        </div>
        <div v-else class="item">
          <div class="title">Archivo</div>
          <div class="box  flex justify-evenly">
            <div>📁</div>
            <div>No disponible</div>
          </div>
        </div>
      </div>

      <div class="border-t-2 mx-2 mt-4 px-4"></div>

      
     <div class="px-4">
      <div v-show="showCard" class="card-no-show">
        <div class="item col-span-2">
          <div class="title">Comentarios</div>
          <input disabled v-model="convalidation.comments"
            class="box  border-primary p-4 ">
        </div>
        <div class="item">
          <div class="title">Revisado por</div>
          <div class="box"> {{ convalidation.approves_user }} </div>
        </div>


      </div>

     </div>
    </div>
    <button @click="toggleCardShow" class="bg-primary rounded-b-lg opacity-80"
      :class="{ 'bg-secondary': showCard, 'bg-primary': !showCard }">
      {{ showCard ? '⇑ ' : ' ... ' }}
    </button>

  </main>

</template>


<style scoped lang="postcss">


.main {
  @apply flex flex-col;
}

.item {
  @apply flex flex-col;
}

.title {
  @apply font-bold;
}

.box {
  @apply flex items-center;
}


.card-show {
  @apply grid grid-cols-3 gap-y-4 gap-x-10;
}

.card-no-show {
  @apply grid grid-cols-3 gap-y-4 gap-x-10 pt-4;
}

</style>