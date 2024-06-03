<script setup lang="ts">
import type { ConvalidationResponse, ConvalidationBase, ConvalidationPost } from "@/interfaces/convalidation_model";
import formatReadableDate from '@/helpers/format_date';
import { ref } from "vue";
import { useConvalidationsStore } from '@/stores/convalidation_store';
import { Icon } from "@iconify/vue";
import ConfirmationDialog from "@/common/dialogs/ConfirmationDialog.vue";
import AlertDialog from "@/common/dialogs/AlertDialog.vue";
import SuccessDialog from "@/common/dialogs/SuccessDialog.vue";
import downloadPdf from "@/helpers/download_file";



import {
      Select,
      SelectContent,
      SelectGroup,
      SelectItem,
      SelectTrigger,
      SelectValue,
} from '@/common/select'

import { ConvalidationStates } from "@/enums/convalidation_states";


const emit = defineEmits(['update-list']);

const props = defineProps<{
  convalidation: ConvalidationResponse;
}>();

const showCard = ref(false);

function toggleCardShow() {
  showCard.value = !showCard.value;
}




const convalidationsStore = useConvalidationsStore();

async function updateConvalidationHandler() {
  if (props.convalidation.state === ConvalidationStates.ENVIADA) {
    toggleConfirmationDialog();
    toggleAlertDialog("El estado de la convalidación no ha cambiado");
    return;
  }

  let update_data = {
    id: props.convalidation.id,
    state: props.convalidation.state,
    comments: props.convalidation.comments,
  };

  try {
    await convalidationsStore.updateConvalidationStore(update_data);
    toggleConfirmationDialog();
    toggleSuccessDialog();
  } catch (error) {
    toggleConfirmationDialog();
    toggleAlertDialog("No se pudo enviar la convalidación");
  }
}



const showConfirmationDialog = ref<boolean>(false);  


function toggleConfirmationDialog() {
  showConfirmationDialog.value = !showConfirmationDialog.value;
}

const showAlertDialog = ref<boolean>(false);
const messageAlert = ref<string>('');

function toggleAlertDialog(message: string ) {
  messageAlert.value = message;
  showAlertDialog.value = !showAlertDialog.value;
}


const showSuccessDialog = ref<boolean>(false);

function toggleSuccessDialog() {
  if (showSuccessDialog.value) {
    showSuccessDialog.value = false;
    emit('update-list');
  } else {
    showSuccessDialog.value = true;
  }
}






</script>

<template>

  <ConfirmationDialog
    :isOpen="showConfirmationDialog"
    title="Enviar Convalidación"
    message="¿Está seguro de enviar la convalidación?"
    @confirm="updateConvalidationHandler"
    @cancel="toggleConfirmationDialog"
  />

  <AlertDialog
    :isOpen="showAlertDialog"
    title="Error"
    :message="messageAlert"
    @close="toggleAlertDialog"
  />

  <SuccessDialog
    :isOpen="showSuccessDialog"
    title="Convalidación Enviada"
    message="La convalidación ha sido enviada correctamente"
    @close="toggleSuccessDialog"
  />

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
                📄 Descargar Certificado
              </button>
              <button
                v-else-if="props.convalidation.convalidation_type == 'Proyecto Personal'"
                @click="downloadPdf(props.convalidation.file_data)">
                📄 Descargar Proyecto
              </button>
              <button v-else disabled> - </button>
            </div>
          </div>
        </div>
      </div>
      <transition name="accordion">
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
                {{ formatReadableDate(props.convalidation.revision_date) }}
              </div>
            </div>
          </div>
          <div class="line"></div>
          <div class="rows grid-cols-3">
            <div class="item col-span-2 row-span-2">
              <div class="title">COMENTARIOS</div>
              <input v-model="props.convalidation.comments" class="comment-box"></input>
            </div>
            
            <div class="item flex">
              <div class="title">
                Estado
              </div>
      
              <Select v-model="convalidation.state">
                <SelectTrigger class="h-full overflow-hidden mt-1">
                  <SelectValue placeholder="Estado" />
                </SelectTrigger>
                <SelectContent>
                  <SelectGroup>
                    <SelectItem value="Enviada">
                      Enviada
                    </SelectItem>
                    <SelectItem value="Rechazada">
                      Rechazada
                    </SelectItem>
                    <SelectItem value="Aprobada por DI">
                      Aprobada por DI
                    </SelectItem>
                    <SelectItem value="En espera de DE">
                      En espera de DE
                    </SelectItem>
                    <SelectItem value="Aprobada por DE">
                      Aprobada por DE
                    </SelectItem>
                  </SelectGroup>
                </SelectContent>
              </Select>
            </div>


            <button class="send-button" @click="toggleConfirmationDialog">
                Enviar Revisión
            </button>
          </div>
        </div>
      </transition>
    </div>
    <div @click="toggleCardShow" class="rounded-b-lg flex justify-center p-1 opacity-80 cursor-pointer bg-primary">
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
  @apply flex flex-col border-2 border-b-0 border-border rounded-lg rounded-b-none p-10 pb-0 mt-4 bg-card;
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
  @apply flex rounded-lg p-2 mt-1 h-full bg-input;
}

.state-box {
  @apply flex items-center border-2 rounded-lg p-2 mt-1 bg-input;
}

.comment-box {
  @apply  flex rounded-lg p-2 mt-1 h-full bg-input border border-primary text-sm ring-offset-background   placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50;

}

.hidden-card {
  @apply flex flex-col;
}

.line {
  @apply border-t mt-8 mb-6;
}

.download-button {
  @apply hover:text-blue-500;
}

.send-button {
  @apply bg-primary text-foreground rounded-lg p-2 mt-1 hover:opacity-80;
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
