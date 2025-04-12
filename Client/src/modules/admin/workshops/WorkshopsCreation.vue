<template>
  <SuccessDialog
    :isOpen="showSuccessDialog"
    title="Taller agregado"
    message="El taller ha sido agregado"
    @close="toggleSuccessDialog"
  />

  <AlertDialog
    :isOpen="showErrorDialog"
    title="Error"
    message="No se pudo agregar el taller, por favor intenta de nuevo"
    @close="toggleErrorDialog"
  />

  <ConfirmationDialog
    :isOpen="showConfirmationDialog"
    title="Agregar Taller"
    message="¿Está seguro de agregar el taller?"
    @confirm="insertWorkshopHandler"
    @cancel="toggleConfirmationDialog"
    class="z-20"
  />

  <div v-if="visible" class="modal-overlay">
    <div class="modal-container">
      <!-- Formulario para añadir un nuevo taller -->
      <div class="">
        <h2 class="modal-title uppercase">Añadir Nuevo Taller</h2>

        <div class="grid grid-cols-2 gap-4">
          <!-- Campo de entrada para el nombre -->
          <div class="col-span-1">
            <label for="name" class="form-label">Nombre del Taller:</label>
            <input
              type="text"
              id="name"
              v-model="workshop.name"
              class="form-input w-full"
            />
          </div>

          <div class="flex flex-cols-3 gap-2 justify-between">
            <!-- Campo de entrada para el año -->
            <div class="form-group col-span-3">
              <label for="year" class="form-label">Año:</label>
              <input
                type="number"
                id="year"
                v-model="workshop.year"
                class="form-input"
              />
            </div>

            <!-- Campo de selección para el semestre -->
            <div class="form-group col-span-1">
              <label for="semester" class="form-label">Semestre:</label>
              <select
                id="semester"
                v-model="workshop.semester"
                class="form-input"
              >
                <option value="1">1</option>
                <option value="2">2</option>
              </select>
            </div>
          </div>
        </div>

        <div class="grid grid-cols-10 gap-2">
          <!-- Campo de entrada para el profesor -->
          <div class="col-span-4">
            <label for="professor" class="form-label">Profesor:</label>
            <input
              type="text"
              id="professor"
              v-model="workshop.professor"
              class="form-input w-full"
            />
          </div>

          <div class="flex flex-cols-1 gap-2">
            <!-- Campos de entrada para la fecha (día, mes, año) -->
            <div class="form-group col-span-1">
              <label for="initial_date" class="form-label"
                >Fecha Inicial:</label
              >
              <input
                v-model="workshop.initial_date"
                id="date_lower_bound"
                type="datetime-local"
                class="bg-input p-2 border border-border rounded-lg"
              />
            </div>

            <div class="form-group col-span-1">
              <label for="initial_date" class="form-label"
                >Termino de inscripciones:</label
              >
              <input
                v-model="workshop.inscription_deadline"
                id="date_lower_bound"
                type="datetime-local"
                class="bg-input p-2 border border-border rounded-lg"
              />
            </div>
          </div>
        </div>

        <!-- Campo de entrada para el archivo -->
        <div class="form-group">
          <label for="file_data" class="form-label pb-1">Archivo (Syllabus)</label>
          <label class="upload-label border border-border">
            <template v-if="!selectedFileName">
              <svg
                xmlns="http://www.w3.org/2000/svg"
                class="icon-upload"
                fill="none"
                viewBox="0 0 24 24"
                stroke="currentColor"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M12 4v16m8-8H4"
                />
              </svg>
              <span class="upload-text">Subir Archivo (.pdf)</span>
            </template>
            <span v-else class="upload-text  ">{{ selectedFileName }}</span>
            <input
              type="file"
              class="hidden "
              id="file_data"
              @change="handleFileUpload"
            />
          </label>
        </div>
      </div>

      <!-- Botones de acción -->
      <div class="modal-actions">
        <button @click="toggleConfirmationDialog" class="btn-primary">
          Guardar
        </button>
        <button @click="close" class="btn-secondary">Cerrar</button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, defineProps, defineEmits, watch } from "vue";
import type { WorkshopPost } from "@/interfaces/workshop_model";
import { insertWorkshop } from "@/services/workshop_api";

import AlertDialog from "@/common/dialogs/AlertDialog.vue";
import SuccessDialog from "@/common/dialogs/SuccessDialog.vue";
import ConfirmationDialog from "@/common/dialogs/ConfirmationDialog.vue";

const props = defineProps<{
  visible: boolean;
}>();

const emit = defineEmits(["close", "update-list"]);

const close = () => {
  emit("close");
};

const update = () => {
  emit("update-list");
};
const workshop = ref<WorkshopPost>({
  name: "",
  semester: null,
  year: null,
  professor: "",
  initial_date: "",
  inscription_deadline: "",
  file_data: null,
});

const showSuccessDialog = ref<boolean>(false);
const showErrorDialog = ref<boolean>(false);
const showConfirmationDialog = ref<boolean>(false);

const selectedFileName = ref<string | null>(null);

const handleFileUpload = (event: Event) => {
  const file = (event.target as HTMLInputElement).files?.[0] || null;
  workshop.value.file_data = file;
  selectedFileName.value = file ? file.name : null; // Actualiza el nombre del archivo seleccionado
};

async function insertWorkshopHandler() {
  try {
    await insertWorkshop(workshop.value);
    toggleConfirmationDialog();
    toggleSuccessDialog();
    update()
    close();
  } catch (error) {
    toggleConfirmationDialog();
    toggleErrorDialog();
  }
}

function toggleErrorDialog() {
  showErrorDialog.value = !showErrorDialog.value;
}

function toggleSuccessDialog() {
  if (showSuccessDialog.value) {
    showSuccessDialog.value = false;
  } else {
    showSuccessDialog.value = true;
  }
}

function toggleConfirmationDialog() {
  if (showConfirmationDialog.value) {
    showConfirmationDialog.value = false;
  } else {
    showConfirmationDialog.value = true;
  }
}
</script>

<style scoped lang="postcss">
.modal-overlay {
  @apply fixed inset-0 bg-black bg-opacity-80 flex justify-center items-center;
}

.modal-container {
  @apply bg-background p-12 rounded-xl shadow-2xl w-2/5 flex flex-col justify-between;
}

.modal-title {
  @apply text-4xl font-bold mb-8 border-b border-border p-4 text-center text-primary;
}

.modal-content {
  @apply space-y-6;
}

.form-group {
  @apply mb-4;
}

.form-label {
  @apply block text-xs font-medium text-foreground mb-1 uppercase;
}

.form-input {
  @apply p-2 bg-input rounded-md border border-border text-card-foreground;
}

.date-inputs {
  @apply flex space-x-2;
}

.upload-label {
  @apply flex flex-col items-center w-full px-4 py-6 bg-input text-muted-foreground uppercase rounded-lg shadow-md cursor-pointer hover:bg-muted transition;
}

.icon-upload {
  @apply h-8 w-8 text-foreground mb-2;
}

.upload-text {
  @apply text-sm font-medium text-center;
}

.modal-actions {
  @apply mt-6 flex justify-end space-x-4;
}

.btn-primary {
  @apply bg-primary text-foreground px-6 py-2 rounded-lg hover:bg-opacity-90 transition;
}

.btn-secondary {
  @apply bg-destructive text-foreground px-6 py-2 rounded-lg hover:bg-destructive-hover transition;
}
</style>
