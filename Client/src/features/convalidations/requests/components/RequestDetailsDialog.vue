<template>
  <ConfirmationDialog
    :isOpen="showConfirmationDialog"
    title="Enviar revisión"
    message="¿Está seguro de terminar la revisíon?"
    @confirm="updateRequestHandler"
    @cancel="toggleConfirmationDialog"
    class="z-20"
  />

  <AlertDialog
    :isOpen="showAlertDialog"
    title="Error"
    :message="messageAlert"
    @close="toggleAlertDialog"
    class="z-20"
  />

  <SuccessDialog
    :isOpen="showSuccessDialog"
    title="Convalidación Enviada"
    message="La convalidación ha sido enviada correctamente"
    @close="toggleSuccessDialog"
    class="z-20"
  />

  <div
    v-if="isOpen"
    class="fixed inset-0 bg-black bg-opacity-50 flex justify-center items-center z-10"
  >
    <div
      class="bg-card rounded-lg py-10 px-20 w-3/5 h-5/6 shadow-lg space-y-6 overflow-y-scroll"
    >
      <section>
        <div class="mb-6 border-b border-border pb-4">
          <h2 class="text-4xl font-bold text-foreground uppercase">
            REVISIÓN DE SOLICITUD
          </h2>
        </div>

        <!-- Información Principal -->
        <div class="flex flex-row gap-4 w-full">
          <!-- ID -->
          <section class="flex flex-col w-1/2 gap-3">
            <div>
              <label class="font-semibold block text-muted-foreground"
                >ID</label
              >
              <p
                class="p-2 bg-input rounded-md border border-border text-card-foreground"
              >
                {{ request.id }}
              </p>
            </div>

            <!-- RUT -->
            <div>
              <label class="font-semibold block text-muted-foreground"
                >RUT</label
              >
              <p
                class="p-2 bg-input rounded-md border border-border text-card-foreground"
              >
                {{ request.rut_student }}
              </p>
            </div>

            <!-- Nombre -->
            <div>
              <label class="font-semibold block text-muted-foreground"
                >NOMBRE</label
              >
              <p
                class="p-2 bg-input rounded-md border border-border text-card-foreground"
              >
                {{ request.name_student }}
              </p>
            </div>
          </section>

          <!-- Rol -->
          <section class="flex flex-col w-1/2 gap-3">
            <div>
              <label class="font-semibold block text-muted-foreground"
                >ROL</label
              >
              <p
                class="p-2 bg-input rounded-md border border-border text-card-foreground"
              >
                {{ request.rol_student }}
              </p>
            </div>

            <!-- Campus -->
            <div>
              <label class="font-semibold block text-muted-foreground"
                >CAMPUS</label
              >
              <p
                class="p-2 bg-input rounded-md border border-border text-card-foreground"
              >
                {{ request.campus_student }}
              </p>
            </div>

            <!-- Fecha de Creación -->
            <div>
              <label class="font-semibold block text-muted-foreground"
                >FECHA DE CREACIÓN</label
              >
              <p
                class="p-2 bg-input rounded-md border border-border text-card-foreground"
              >
                {{ formatReadableDate(request.creation_date) }}
              </p>
            </div>
          </section>
        </div>
      </section>

      <!-- Convalidaciones -->

      <section>
        <h2
          class="text-2xl font-bold mb-6 text-primary uppercase border-b pb-4"
        >
          Convalidaciones
        </h2>

        <div class="">
          <!-- Iterar sobre las convalidaciones -->
          <div
            v-for="convalidation in request.convalidations"
            :key="convalidation.id"
            class="bg-card rounded-lg shadow-lg p-6 border border-border"
          >
            <!-- Contenido de la Card -->
            <div class="grid grid-cols-2 gap-4">
              <!-- Tipo de Convalidación -->
              <div>
                <label
                  class="font-semibold block text-muted-foreground uppercase"
                  >Tipo de Convalidación</label
                >
                <p
                  class="p-2 bg-input rounded-md border border-border text-card-foreground"
                >
                  {{ convalidation.convalidation_type }}
                </p>
              </div>

              <!-- Asignatura a Convalidar -->
              <div>
                <label
                  class="font-semibold block text-muted-foreground uppercase"
                  >Asignatura a Convalidar</label
                >
                <p
                  class="p-2 bg-input rounded-md border border-border text-card-foreground"
                >
                  {{ convalidation.curriculum_course }}
                </p>
              </div>

              <!-- Asignatura Cursada o Detalle -->
              <div>
                <div v-if="convalidation.id_subject_to_convalidate">
                  <div class="grid grid-cols-10 gap-x-4">
                    <div class="flex flex-col col-span-2">
                      <label
                        class="font-semibold block text-muted-foreground uppercase"
                      >
                        SIGLA
                      </label>
                      <p
                        class="p-2 bg-input rounded-md border border-border text-card-foreground"
                      >
                        {{
                          getSubjectAcronym(
                            convalidation.id_subject_to_convalidate
                          )
                        }}
                      </p>
                    </div>
                    <div class="col-span-8">
                      <label
                        class="font-semibold block text-muted-foreground uppercase"
                      >
                        Asignatura Cursada
                      </label>
                      <p
                        class="p-2 bg-input rounded-md border border-border text-card-foreground"
                      >
                        {{ convalidation.subject }}
                      </p>
                    </div>
                  </div>
                </div>

                <div v-if="convalidation.id_workshop_to_convalidate">
                  <label
                    v-if="convalidation.id_workshop_to_convalidate"
                    class="font-semibold block text-muted-foreground uppercase"
                  >
                    Taller
                  </label>

                  <p
                    v-if="convalidation.id_workshop_to_convalidate"
                    class="p-2 bg-input rounded-md border border-border text-card-foreground"
                  >
                    {{ convalidation.workshop }}
                  </p>
                </div>

                <div
                  v-if="
                    convalidation.certified_course_name ||
                    convalidation.personal_project_name
                  "
                >
                  <label
                    v-if="convalidation.certified_course_name"
                    class="font-semibold block text-muted-foreground uppercase"
                  >
                    Curso Certificado
                  </label>
                  <p
                    v-if="convalidation.certified_course_name"
                    class="p-2 bg-input rounded-md border border-border text-card-foreground uppercase"
                  >
                    {{ convalidation.certified_course_name }}
                  </p>
                </div>

                <div>
                  <label
                    v-if="convalidation.personal_project_name"
                    class="font-semibold block text-muted-foreground uppercase"
                  >
                    Proyecto Personal
                  </label>
                  <p
                    v-if="convalidation.personal_project_name"
                    class="p-2 bg-input rounded-md border border-border text-card-foreground uppercase"
                  >
                    {{ convalidation.personal_project_name }}
                  </p>
                </div>
              </div>

              <!-- Archivo Adjunto -->
              <div>
                <label
                  class="font-semibold block text-muted-foreground uppercase"
                  >Archivo Adjunto</label
                >
                <button
                  v-if="convalidation.file_data"
                  @click="downloadPdf(convalidation.file_data)"
                  class="p-2 bg-muted rounded-md border border-border hover:bg-muted/70 flex items-center space-x-2 w-3/4"
                >
                  <Icon icon="carbon:document" class="text-lg" />
                  <span>{{ convalidation.file_name }}</span>
                </button>
                <p
                  v-else
                  class="p-2 bg-input rounded-md border border-border uppercase text-muted text-center"
                >
                  Sin archivo adjunto
                </p>
              </div>

              <div class="grid grid-rows-2">
                <p
                  class="font-semibold block row-start-2 text-muted-foreground uppercase"
                >
                  Estado de la solicitud:
                </p>
              </div>

              <!-- Estado -->
              <div class="grid grid-rows-2 grid-cols-2 select-none">
                <select
                  v-model="convalidation.state"
                  class="p-2 select-none row-start-2 col-start-2 rounded-md border border-border cursor-pointer focus:ring-1 focus:ring-primary transition"
                  :class="{
                    'bg-muted': convalidation.state == 'Enviada',
                    'bg-destructive text-destructive-foreground':
                      convalidation.state == 'Rechazada',
                    'bg-success ':
                      convalidation.state == 'Aprobada por DI' ||
                      convalidation.state == 'Aprobada por DE' ||
                      convalidation.state == 'En espera de DE',
                  }"
                >
                  <option class="bg-input hover:bg-muted" value="Enviada">
                    Enviada
                  </option>
                  <option class="bg-input hover:bg-primary" value="Rechazada">
                    Rechazada
                  </option>
                  <option
                    class="bg-input hover:bg-primary"
                    value="Aprobada por DI"
                  >
                    Aprobada por DI
                  </option>
                  <option
                    class="bg-input hover:bg-primary"
                    value="En espera de DE"
                  >
                    En espera de DE
                  </option>
                  <!-- <option
                    class="bg-input hover:bg-primary"
                    value="Aprobada por DE"
                  >
                    Aprobada por DE
                  </option> -->
                </select>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- Comentarios -->
      <section>
        <h2 class="text-2xl font-bold mb-4 text-primary border-b pb-4">
          COMENTARIOS
        </h2>
        <div class="grid grid-cols-3 gap-4">
          <textarea
            v-model="request.comments"
            class="col-span-3 p-4 bg-input rounded-md border border-border resize-none hover:ring ring-ring focus:ring-ring focus:ring-offset-2 focus:ring-offset-background focus:outline-none focus:ring-2"
            rows="4"
            placeholder="Escribe tus comentarios aquí..."
          ></textarea>
        </div>
      </section>

      <!-- Botón para Cerrar -->
      <div class="text-right mt-6 flex justify-end gap-4">
        <button
          @click="closeDialog"
          class="bg-destructive text-foreground px-6 py-2 rounded-lg hover:opacity-80"
        >
          Cerrar
        </button>
        <button
          class="bg-primary text-foreground rounded-md p-2 hover:opacity-90"
          @click="toggleConfirmationDialog"
        >
          Enviar Revisión
        </button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { defineProps, defineEmits, ref, onMounted } from "vue";
import formatReadableDate from "@/shared/helpers/format_date";
import downloadPdf from "@/shared/helpers/download_file";

import { Icon } from "@iconify/vue";

import ConfirmationDialog from "@/shared/components/dialogs/ConfirmationDialog.vue";
import AlertDialog from "@/shared/components/dialogs/AlertDialog.vue";
import SuccessDialog from "@/shared/components/dialogs/SuccessDialog.vue";

import { RequestStates } from "@/shared/enums/request_states";
import { useRequestStore } from "@/shared/stores/request_store";

import type {
  RequestResponse,
  RequestUpdate,
} from "@/interfaces/request_model";

import type { SubjectResponse } from "@/interfaces/subject_model";

import {
  Select,
  SelectContent,
  SelectGroup,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/shared/components/ui/select";

import { getAllSubject } from "@/shared/services/api/subject_api";

const props = defineProps({
  isOpen: {
    type: Boolean,
    required: true,
  },
  request: {
    type: Object as () => RequestResponse,
    required: true,
  },
});

const emit = defineEmits(["close", "update-list"]);

function closeDialog() {
  emit("close");
}

const showAlertDialog = ref<boolean>(false);
const showConfirmationDialog = ref<boolean>(false);
const messageAlert = ref<string>("");
const showSuccessDialog = ref<boolean>(false);

const request_store = useRequestStore();

const subjects = ref<SubjectResponse[]>([]);

function toggleConfirmationDialog() {
  showConfirmationDialog.value = !showConfirmationDialog.value;
}

function toggleAlertDialog(message: string) {
  messageAlert.value = message;
  showAlertDialog.value = !showAlertDialog.value;
}

function toggleSuccessDialog() {
  if (showSuccessDialog.value) {
    showSuccessDialog.value = false;
    emit("close");
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

const getSubjectHandler = async () => {
  try {
    subjects.value = await getAllSubject();
  } catch (error) {
    console.error(error);
  }
};

// Sacar SIGLA de la asignatura

function getSubjectAcronym(id_subject_to_convalidate: number) {
  const subject = subjects.value.find(
    (subject) => subject.id == id_subject_to_convalidate
  );
  return subject ? subject.acronym : "-";
}

onMounted(() => {
  getSubjectHandler();
});
</script>

<style scoped lang="postcss">
.main {
  @apply w-full flex flex-col min-w-[1000px] mb-10;
}

.card {
  @apply flex flex-col rounded-lg rounded-b-none p-10 pb-0 mt-4 bg-card;
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
</style>
