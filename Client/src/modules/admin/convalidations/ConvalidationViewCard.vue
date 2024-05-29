<script setup lang="ts">
import type { ConvalidationResponse } from "@/interfaces/convalidation_model";
import formatReadableDate from '@/helpers/format_date';
import { ref } from "vue";
import { Icon } from "@iconify/vue";

const props = defineProps<{
  convalidation: ConvalidationResponse;
}>();

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
  const blob = new Blob([bytes], { type: "application/pdf" });
  const pdfUrl = URL.createObjectURL(blob);
  const anchor = document.createElement("a");
  anchor.href = pdfUrl;
  anchor.target = "_blank";
  anchor.setAttribute("Descargar", "file");
  document.body.appendChild(anchor);
  anchor.click();
  document.body.removeChild(anchor);
}
</script>

<template>
  <main class="main">
    <div class="card">
      <div class="visible-card">
        <div class="rows grid-cols-7">
          <div class="item">
            <div class="title">ID</div>
            <div class="box">
              {{ props.convalidation.id }}
            </div>
          </div>
          <div class="item col-span-2">
            <div class="title">ROL ESTUDIANTE</div>
            <div class="box">
              {{ props.convalidation.student_rol }}
            </div>
          </div>
          <div class="item col-span-2">
            <div class="title">NOMBRE ESTUDIANTE</div>
            <div class="box">
              {{ props.convalidation.student_name }}
            </div>
          </div>
          <div class="item col-span-2">
            <div class="title">TIPO DE CONVALIDACIÓN</div>
            <div class="box">
              {{ props.convalidation.convalidation_type }}
            </div>
          </div>       
        </div>
        
        <div class="rows grid-cols-3">
          <div class="item">
            <div class="title">CURSO A CONVALIDAR</div>
            <div class="box">
              {{ props.convalidation.curriculum_course }}
            </div>
          </div>
          <div v-if="props.convalidation.subject !== null" class="item">
            <div class="title">ASIGNATURA CURSADA</div>
            <div class="box">{{ props.convalidation.subject }}</div>
          </div>

          <div v-if="props.convalidation.workshop !== null" class="item ">
            <div class="title">TALLER CURSADO</div>
            <div class="box">{{ props.convalidation.workshop }}</div>
          </div>
          <div v-if="props.convalidation.certified_course_name !== null" class="item">
            <div class="title">CURSO REALIZADO</div>
            <div class="box">{{ props.convalidation.certified_course_name }}</div>
          </div>
          <div v-if="props.convalidation.personal_project_name !== null" class="item">
            <div class="title">PROYECTO CURSADO</div>
            <div class="box">{{ props.convalidation.personal_project_name }}</div>
          </div>
          <div class="item">
            <div class="title">Archivo</div>
            <div class="box">
              <button class="download-button"
                v-if="props.convalidation.convalidation_type == 'Curso Certificado'"
                @click="downloadPdf(props.convalidation.file_data)">
                📁 Descargar Certificado
              </button>
              <button
                v-else-if="props.convalidation.convalidation_type == 'Proyecto Personal'"
                @click="downloadPdf(props.convalidation.file_data)">
                📁 Descargar Proyecto
              </button>
              <button v-else disabled> 🚫 No disponible</button>
            </div>
          </div>
        </div>
      </div>
      <div v-show="showCard" class="hidden-card">
        <div class="grid grid-cols-2 gap-5">
          <div class="item">

            <div class="title">FECHA DE CREACIÓN</div>
            <div class="box">
              {{ formatReadableDate(props.convalidation.creation_date) }}
            </div>
          </div>

          <div class="item">
            <div class="title">FECHA DE APROBACIÓN</div>
            <div class="box">
              {{ formatReadableDate(props.convalidation.approval_date) }}
            </div>
          </div>
         

        </div>

        <div class="line"></div>

        <div class="rows grid-cols-3">
          <div class="item col-span-2 row-span-2">
            <div class="title">COMENTARIOS</div>
            <div class="box bg-input">
              {{ props.convalidation.comments }}
            </div>
          </div>
          
          <div class="item">
            <div class="title">ESTADO</div>
            <div class="state-box" :class="{
              'border-success': props.convalidation.state === 'Aprobada por DI' || props.convalidation.state === 'Aprobada por DE',
              'border-destructive': props.convalidation.state === 'Rechazada',
              'border border-yellow-500': props.convalidation.state === 'Enviada'
            }">{{ props.convalidation.state }}</div>
          </div>

          
          <div class="item">
            <div class="title">APROBADA POR</div>
            <div class="box">
              {{ props.convalidation.approved_by? props.convalidation.approved_by : '-'}}
            </div>
            </div>

        </div>
        

        
      
      </div>
    </div>
    <div @click="toggleCardShow" class="rounded-b-lg flex justify-center p-1 opacity-80 cursor-pointer"
      :class="{ 'bg-input': showCard, 'bg-primary': !showCard }">
      <Icon icon="teenyicons:up-small-outline" class="icon" v-if="showCard" />
      <Icon icon="teenyicons:down-small-outline" class="icon" v-else />
    </div>
  </main>
</template>

<style scoped lang="postcss">
.main {
  @apply w-full flex flex-col min-w-[1000px] mb-10;
}

.card {
  @apply flex flex-col border-2 border-border rounded-lg rounded-b-none p-6 pb-0 mt-4;
}

.rows {
  @apply grid gap-5 pb-5;
}

.item {
  @apply flex flex-col font-mono;
}

.title {
  @apply font-bold text-xs pl-1;
}

.box {
  @apply flex items-center border-2 border-border rounded-lg p-2 mt-1 h-full;
}

.state-box {
  @apply flex items-center border-2 rounded-lg p-2 mt-1;

}

.hidden-card {
  @apply flex flex-col;
}

.line {
  @apply border-t-2 mt-8 mb-6 ;
}
</style>
