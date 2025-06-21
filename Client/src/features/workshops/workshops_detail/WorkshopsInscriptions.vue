<template>
  <main class="mb-10">
    <!-- Título -->
    <div>
      <p class="text-3xl pb-5 font-bold">Inscripciones</p>
    </div>

    <!-- Contenedor de la Tabla -->

    <div class="overflow-x-auto">
      <table
        class="table-auto w-full bg-card text-card-foreground rounded-xl shadow-md border border-border"
      >
        <thead class="bg-muted text-muted-foreground">
          <tr>
            <th class="px-6 py-3 text-left uppercase text-sm font-semibold">
              RUT
            </th>
            <th class="px-6 py-3 text-left uppercase text-sm font-semibold">
              Nombre
            </th>
            <th class="px-6 py-3 text-left uppercase text-sm font-semibold">
              Libre a Convalidar
            </th>
          </tr>
        </thead>
        <tbody>
          <tr
            v-if="workshops_inscriptions.length === 0"
            class="text-muted italic p-5"
          >
            <td colspan="3" class="px-6 py-3 text-center">
              No hay inscripciones
            </td>
          </tr>
          <tr
            v-for="inscription in workshops_inscriptions"
            :key="inscription.rut_student"
            class="hover:bg-muted/70 transition-colors duration-200"
          >
            <td class="px-6 py-3 border-t border-border">
              {{ inscription.rut_student }}
            </td>
            <td class="px-6 py-3 border-t border-border">
              {{ inscription.name_student }}
            </td>
            <td class="px-6 py-3 border-t border-border">
              {{ inscription.curriculum_course }}
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- Subir Excel -->
    <div class="pt-10 flex flex-col items-center space-y-4">
      <!-- Contenedor para Subir Archivos -->
      <label
        class="flex flex-col items-center w-64 px-4 py-6 bg-input text-muted-foreground rounded-lg shadow-md cursor-pointer hover:bg-muted/80 transition"
      >
        <!-- Mostrar SVG y texto solo si no hay archivo seleccionado -->
        <template v-if="!selectedFileName">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            class="h-8 w-8 mb-2 text-foreground"
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
          <span class="text-sm font-medium">Subir Archivo Excel (.xlsx)</span>
        </template>

        <!-- Mostrar solo el nombre del archivo cuando sea seleccionado -->
        <span class="text-sm font-medium" v-else>{{ selectedFileName }}</span>
        <input
          type="file"
          class="hidden"
          ref="fileInput"
          accept=".xlsx"
          @change="handleFileChange"
        />
      </label>

      <div class="flex justify-end w-full gap-8">
        <!-- Botón para procesar -->
        <button
          class="px-6 py-3 bg-primary text-foreground rounded-lg hover:bg-secondary/90 transition"
          @click="processExcel"
        >
          Procesar Archivo
        </button>

        <button
          class="px-6 py-3 bg-secondary text-foreground rounded-lg hover:bg-secondary/90 transition"
          @click="closeWorkshop"
        >
          Cerrar Taller
        </button>
      </div>
    </div>
  </main>
</template>

<script setup lang="ts">
import { ref, onMounted } from "vue";
import type { WorkshopsInscriptionsResponse } from "@/interfaces/workshop_inscription_model";
import {
  getWorkshopsInscriptionsByWorkshopId,
} from "@/shared/services/api/workshop_inscriptions_api";

import { updateWorkshopAvailable } from "@/shared/services/api/workshop_api";

import * as XLSX from "xlsx";

const props = defineProps<{
  id_workshop: number;
}>();

// Estado
const workshops_inscriptions = ref<WorkshopsInscriptionsResponse[]>([]);
const fileInput = ref<HTMLInputElement | null>(null);
const selectedFileName = ref<string | null>(null); // Almacena el nombre del archivo seleccionado

// Obtener inscripciones desde la API
async function getWorkshopsInscriptionsByWorkshopIdHandler() {
  try {
    workshops_inscriptions.value = await getWorkshopsInscriptionsByWorkshopId(
      props.id_workshop
    );
  } catch (error) {
    console.error("Error al obtener inscripciones:", error);
  }
}

// Manejar la selección del archivo
const handleFileChange = (event: Event) => {
  const input = event.target as HTMLInputElement;
  if (input.files && input.files.length > 0) {
    selectedFileName.value = input.files[0].name; // Muestra el nombre del archivo seleccionado
  }
};

// Cerrar taller
const closeWorkshop = async () => {
  try {
    await updateWorkshopAvailable(props.id_workshop, false);
    alert("Taller cerrado exitosamente");
  } catch (error) {
    console.error("Error al cerrar el taller:", error);
  }
};

// Procesar archivo Excel
const processExcel = () => {
  if (fileInput.value && fileInput.value.files.length > 0) {
    const file = fileInput.value.files[0];
    const reader = new FileReader();

    reader.onload = (e) => {
      const data = new Uint8Array(e.target?.result as ArrayBuffer);
      const workbook = XLSX.read(data, { type: "array" });
      const sheetName = workbook.SheetNames[0];
      const sheet = workbook.Sheets[sheetName];
      const jsonData = XLSX.utils.sheet_to_json(sheet) as Array<{
        RUT: string;
        NOTA: string;
      }>;

      console.log("Datos del Excel:", jsonData);
      // Combina datos del Excel con la tabla
      const result = workshops_inscriptions.value.map((item) => {
        const match = jsonData.find((row) => row.RUT.trim() === item.rut_student.trim());
        return {
          RUT: item.rut_student,
          NOMBRE: item.name_student.split(" ")[0], // Nombre
          APELLIDO: item.name_student.split(" ")[1] || "", // Apellido
          NOTA: match ? match.NOTA : "", // Nota del Excel
          LIBRE: item.curriculum_course,
        };
      });

      // Descargar nuevo archivo Excel
      const newWorkbook = XLSX.utils.book_new();
      const newWorksheet = XLSX.utils.json_to_sheet(result);
      XLSX.utils.book_append_sheet(newWorkbook, newWorksheet, "Resultado");
      XLSX.writeFile(newWorkbook, "resultado.xlsx");
    };

    reader.readAsArrayBuffer(file);
  } else {
    alert("Por favor, selecciona un archivo Excel.");
  }
};

// Montar componente
onMounted(getWorkshopsInscriptionsByWorkshopIdHandler);
</script>

<style scoped>
.container {
  @apply w-full p-2 border border-border rounded-3xl;
}

label {
  @apply w-full flex flex-col items-center justify-center cursor-pointer;
}

svg {
  @apply mb-2;
}
</style>
