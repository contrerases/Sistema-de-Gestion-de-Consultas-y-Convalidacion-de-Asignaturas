<script setup lang="ts">
import type { ConvalidationResponse } from "@/interfaces/convalidation_model";
import formatReadableDate from "@/helpers/format_date";
import { ref } from "vue";
import { Icon } from "@iconify/vue";
import downloadPdf from "@/helpers/download_file";

const props = defineProps<{
  convalidation: ConvalidationResponse;
}>();

const showCard = ref(false);

function toggleCardShow() {
  showCard.value = !showCard.value;
}
</script>

<template>
  <main class="main">
    <div class="card">
      <div class="visible-card">
        <div class="rows grid-cols-8">
          <div class="item col-span-2">
            <div class="title">ID</div>
            <div class="box">001</div>
          </div>
          <div class="item col-span-3">
            <div class="title">RUT</div>
            <div class="box">20.369.538-1</div>
          </div>
          <div class="item col-span-3">
            <div class="title">NOMBRE</div>
            <div class="box">CAMILO CONTRERAS ESPINOZA</div>
          </div>
        </div>
        <div class="rows grid-cols-2">
          <div class="item">
            <div class="title">ROL</div>
            <div class="box">201873063-7</div>
          </div>

          <div class="item">
            <div class="title">CAMPUS</div>
            <div class="box">CASA CENTRAL</div>
          </div>
        </div>
      </div>
      <transition name="accordion">
        <div v-show="showCard" class="hidden-card">
          <div class="rows grid-cols-2">
            <div class="item">
              <div class="title">FECHA DE CREACIÓN</div>
              <div class="box">20 de Julio de 2021</div>
            </div>

            <div class="item">
              <div class="title">FECHA DE REVISIÓN</div>
              <div class="box">21 de Julio de 2021</div>
            </div>
          </div>
          
          <div class="text-4xl font-bold py-4">
            Convalidaciones
          </div>
          <div class="line mt-4"></div>
          <div class="rows grid-cols-5">
            <div class="title-table">TIPO DE CONVALIDACION</div>
            <div class="title-table">ASIGNATURA A CONVALIDAR</div>
            <div class="title-table">ASIGNATURA  <br> CURSADA</div>
            <div class="title-table">ARCHIVO <br> ADJUNTO</div>
            <div class="title-table">ESTADO DE <br> SOLICITUD</div>
          </div>

          <div class="line"></div>

          <div class="rows grid-cols-5">
            <div class="item">
              <div class="box">Curso Certificado</div>
            </div>

            <div class="item">
              <div class="box">LIBRE I</div>
            </div>

            <div class="item">
              <div class="box">Javascript</div>
            </div>

            <div class="item">
              <div class="box">📄 archivo.pdf</div>
            </div>

            <div class="item">
              <div class="box">ENVIADA</div>
            </div>
          </div>

          <div class="line"></div>

          <div class="rows grid-cols-5">
            <div class="item">
              <div class="box">Asignatura INF</div>
            </div>

            <div class="item">
              <div class="box">ELECTIVO I</div>
            </div>

            <div class="item">
              <div class="box">INF-234</div>
            </div>

            <div class="item">
              <div class="box">🚫 No Disponible</div>
            </div>

            <div class="item">
              <div class="box">RECHAZADA</div>
            </div>
          </div>

          <div class="line"></div>

          <div class="rows grid-cols-5">
            <div class="item">
              <div class="box">Asignatura INF</div>
            </div>

            <div class="item">
              <div class="box">ELECTIVO II</div>
            </div>

            <div class="item">
              <div class="box">INF-244</div>
            </div>

            <div class="item">
              <div class="box">🚫 No Disponible</div>
            </div>

            <div class="item">
              <div class="box">RECHAZADA</div>
            </div>
          </div>
        </div>
      </transition>
    </div>
    <div
      @click="toggleCardShow"
      class="rounded-b-lg flex justify-center p-1 opacity-80 cursor-pointer bg-primary"
    >
      <Icon icon="teenyicons:up-small-outline" class="icon" v-if="showCard" />
      <Icon icon="teenyicons:down-small-outline" class="icon" v-else />
    </div>
  </main>

  <!-- <div class="box">
    <button class="download-button"
      v-if="props.convalidation.convalidation_type == 'Curso Certificado'"
      @click="downloadPdf(props.convalidation.file_data)">
      📄 Descargar Certificado
    </button>
    <button
      v-else-if="props.convalidation.convalidation_type == 'Proyecto Personal'"
      @click="downloadPdf(props.convalidation.file_data)">
      📄 Descargar Proyecto
    </button>
    <button v-else disabled> - </button>
  </div> 
   <div class="item">
            <div class="title">CURSO A CONVALIDAR</div>
            <div class="box">
              {{ props.convalidation.curriculum_course }}
            </div>
          </div>-->
</template>

<style scoped lang="postcss">
.main {
  @apply w-full flex flex-col min-w-[1000px] mb-10;
}

.card {
  @apply flex flex-col border-2 border-b-0 border-border rounded-lg rounded-b-none p-10 pb-0 mt-4 bg-card;
}

.rows {
  @apply grid gap-5 pb-5;
}

.item {
  @apply flex flex-col font-mono;
}

.title {
  @apply font-bold text-lg pl-1;
}

.title-table {
  @apply font-bold text-sm;
}
.box {
  @apply flex rounded-lg p-2 mt-1 h-full bg-input;
}

.state-box {
  @apply flex items-center border-2 rounded-lg p-2 mt-1 bg-input;
}

.hidden-card {
  @apply flex flex-col pb-4;
}

.line {
  @apply border-t-2 pb-4;
}

.download-button {
  @apply hover:text-blue-500;
}

.accordion-enter-active,
.accordion-leave-active {
  transition: all 0.2s ease-in-out;
}

.accordion-enter-from,
.accordion-leave-to {
  max-height: 0;
  opacity: 0;
}

.accordion-enter-to,
.accordion-leave-from {
  max-height: 500px;
  opacity: 1;
}
</style>
