<script setup lang="ts">
import { ref } from "vue";

import type {
  RequestInsert,
  RequestResponse,
  RequestUpdate,
  Request,
} from "@/interfaces/request_model";

import formatReadableDate from "@/shared/helpers/format_date";
import downloadPdf from "@/shared/helpers/download_file";

import { Icon } from "@iconify/vue";

import ConfirmationDialog from "@/common/dialogs/ConfirmationDialog.vue";
import AlertDialog from "@/common/dialogs/AlertDialog.vue";
import SuccessDialog from "@/common/dialogs/SuccessDialog.vue";

import {
  Select,
  SelectContent,
  SelectGroup,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/common/select";

import { RequestStates } from "@/enums/request_states";
import { useRequestStore } from "@/shared/stores/request_store";

const props = defineProps<{
  request: RequestResponse;
}>();

console.log(props.request);

const emit = defineEmits(["update-list"]);

const showConfirmationDialog = ref<boolean>(false);

const showCard = ref(false);

const showAlertDialog = ref<boolean>(false);
const messageAlert = ref<string>("");
const showSuccessDialog = ref<boolean>(false);

const request_store = useRequestStore();



function toggleConfirmationDialog() {
  showConfirmationDialog.value = !showConfirmationDialog.value;
}

function toggleCardShow() {
  showCard.value = !showCard.value;
}

function toggleAlertDialog(message: string) {
  messageAlert.value = message;
  showAlertDialog.value = !showAlertDialog.value;
}

function toggleSuccessDialog() {
  if (showSuccessDialog.value) {
    showSuccessDialog.value = false;
    emit("update-list");
  } else {
    showSuccessDialog.value = true;
  }
}

async function updateRequestHandler() { 
  let convalidations = props.request.convalidations;
  let canSend = true;
  for (let i = 0; i < convalidations.length; i++) {
    if (convalidations[i].state == RequestStates.ENVIADA) {
      canSend = false;
      break;
    }
  }

  if (!canSend) {
    toggleConfirmationDialog();
    toggleAlertDialog("Algunas convalidaciones no han cambiado su estado");
    return;
  }
 
  
  
  let requestUpdate: RequestUpdate = {
    id: props.request.id,
    comments: props.request.comments,
    id_user_approver: 1,
    convalidations: props.request.convalidations.map((convalidation) => {
      return {
        id: convalidation.id,
        state: convalidation.state,
      };
    }),
  };

 
  try {
    await request_store.updateRequestStore(requestUpdate);
    toggleConfirmationDialog();
    toggleSuccessDialog();
  } catch (error) {
    toggleConfirmationDialog();
    toggleAlertDialog("Error al enviar la revisión");
  }
}


</script>

<template>
  <ConfirmationDialog :isOpen="showConfirmationDialog" title="Enviar revisión"
    message="¿Está seguro de terminar la revisíon?" @confirm="updateRequestHandler"
    @cancel="toggleConfirmationDialog" />

  <AlertDialog :isOpen="showAlertDialog" title="Error" :message="messageAlert" @close="toggleAlertDialog" />

  <SuccessDialog :isOpen="showSuccessDialog" title="Convalidación Enviada"
    message="La convalidación ha sido enviada correctamente" @close="toggleSuccessDialog" />
  <main class="main">
    <div class="card">
      <div class="visible-card">
        <div class="rows grid-cols-8">
          <div class="item col-span-2">
            <div class="title">ID</div>
            <div class="box">{{ request.id }}</div>
          </div>
          <div class="item col-span-3">
            <div class="title">RUT</div>
            <div class="box">{{ request.rut_student }}</div>
          </div>
          <div class="item col-span-3">
            <div class="title">NOMBRE</div>
            <div class="box">{{ request.name_student }}</div>
          </div>
        </div>
        <div class="rows grid-cols-2">
          <div class="item">
            <div class="title">ROL</div>
            <div class="box">{{ request.rol_student }}</div>
          </div>

          <div class="item">
            <div class="title">CAMPUS</div>
            <div class="box">{{ request.campus_student }}</div>
          </div>
        </div>
      </div>
      <transition name="accordion">
        <div v-show="showCard" class="hidden-card">
          <div class="rows grid-cols-2">
            <div class="item">
              <div class="title">FECHA DE CREACIÓN</div>
              <div class="box">
                {{ formatReadableDate(request.creation_date) }}
              </div>
            </div>

            <div class="item">
              <div class="title">FECHA DE REVISIÓN</div>
              <div class="box">
                {{ formatReadableDate(request.revision_date) }}
              </div>
            </div>
          </div>

          <div class="text-4xl font-bold py-2 font-mono">Convalidaciones</div>
          <div class="line mt-2"></div>
          <div class="rows grid-cols-5">
            <div class="title-table">TIPO DE CONVALIDACION</div>
            <div class="title-table">ASIGNATURA A CONVALIDAR</div>
            <div class="title-table">
              ASIGNATURA <br />
              CURSADA
            </div>
            <div class="title-table">
              ARCHIVO <br />
              ADJUNTO
            </div>
            <div class="title-table">
              ESTADO DE <br />
              SOLICITUD
            </div>
          </div>

          <div class="line"></div>

          <div v-for="convalidation in request.convalidations">
            <div class="rows grid-cols-5">

              <div class="item">
                <div class="box">{{ convalidation.convalidation_type }}</div>
              </div>

              <div class="item">
                <div class="box">{{ convalidation.curriculum_course }}</div>
              </div>

              <!--  --------------------------------------------------- -->

              <div v-if="convalidation.id_subject_to_convalidate != null" class="item">
                <div class="box">{{ convalidation.subject }}</div>
              </div>

              <div v-if="convalidation.id_workshop_to_convalidate != null" class="item">
                <div class="box">{{ convalidation.workshop }}</div>
              </div>

              <div v-if="convalidation.certified_course_name != null" class="item">
                <div class="box">{{ convalidation.certified_course_name }}</div>
              </div>

              <div v-if="convalidation.personal_project_name != null" class="item">
                <div class="box">{{ convalidation.personal_project_name }}</div>
              </div>

              <!-- ---------------------------------------------------- -->


              <div class="item">
                <button @click="downloadPdf(convalidation.file_data)" class="box">📄 {{ convalidation.file_name }}</button>
              </div>

              <div class="item">
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
            </div>

            <div class="line"></div>
          </div>

          <div class="item mb-5">
            <div class="title pb-2">COMENTARIOS</div>
            <div class="grid grid-cols-3 gap-5 grid-rows-2">
              <input v-model="request.comments" class="comment-box col-span-2 row-span-2"></input>
              <button class="send-button row-span-2" @click="toggleConfirmationDialog">
                Enviar Revisión
              </button>
            </div>
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

.comment-box {
  @apply flex rounded-lg p-2 pb-4 h-full bg-input border border-primary text-sm ring-offset-background placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50;
}
.send-button {
  @apply bg-primary text-foreground rounded-md hover:opacity-80;
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
