<template>
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

            <!-- Revisador -->

            <div>
              <label class="font-semibold block text-muted-foreground"
                >REVISADOR</label
              >
              <p
                class="p-2 bg-input rounded-md border border-border text-card-foreground"
              >
                {{ request.user_approver || "Sin revisador" }}
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

            <div>
              <label class="font-semibold block text-muted-foreground"
                >FECHA DE REVISION</label
              >
              <p
                class="p-2 bg-input rounded-md border border-border text-card-foreground"
              >
                {{ formatReadableDate(request.revision_date) || "Sin revisión" }}
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
                  <div class="grid grid-cols-3 gap-x-4">
                    <div class="flex flex-col">
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
                    <div class="col-span-2">
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
                <div
                  class="p-2 select-none row-start-2 col-start-2 rounded-md border border-border"
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
                  {{ convalidation.state }}
                </div>
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
        <div class="grid grid-rows-2 gap-4 h-32 overflow-y-auto">
          <div
            class="row-span-2 p-4 bg-input rounded-md border border-border resize-none"   
          >
            {{ request.comments }}
          </div>
        </div>
      </section>

      <div class="text-right mt-6 flex justify-end gap-4">
        <button
          @click="closeDialog"
          class="bg-destructive text-foreground px-6 py-2 rounded-lg hover:opacity-80"
        >
          Cerrar
        </button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { defineProps, ref } from "vue";
import type { Request, RequestResponse } from "@/interfaces/request_model";
import downloadPdf from "@/helpers/download_file";
import formatReadableDate from "@/helpers/format_date";
import {} from "@/stores/subject_store";
import type { SubjectResponse } from "@/interfaces/subject_model";
import { getAllSubject } from "@/services/subject_api";
import { onMounted } from "vue";

const subjects = ref<SubjectResponse[]>([]);

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

const emit = defineEmits(["close"]);

function closeDialog() {
  emit("close");
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

<style scoped lang="postcss"></style>
