<template>
    <main>
        <!-- title -->
        <div>
            <p class="text-3xl pb-5 font-bold">Inscripciones</p>
        </div>

        <div class="container">
            <div class="overflow-x-auto">
              <table class="table">
                <thead class="thead">
                  <tr class="tr-up">
                    <th class="th">RUT</th>
                    <th class="th">NOMBRE</th>
                    <th class="th">LIBRE A CONVALIDAR</th>
                  </tr>
                </thead>
                <tbody class="tbody">
                <div class="text-muted italic p-5" v-if="workshops_inscriptions.length === 0">No hay inscripciones</div>
                  <tr class="tr" v-for="inscription in workshops_inscriptions" >
                    <td class="td">{{ inscription.rut_student }}</td>
                    <td class="td">{{ inscription.name_student }}</td>
                    <td class="td">{{ inscription.curriculum_course }}</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>

          <div>
            <input type="file" ref="fileInput" accept=".xlsx" />
            <button @click="processExcel">Subir y Procesar Excel</button>
          </div>
          
    </main>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';
import type { WorkshopsInscriptionsBase, WorkshopsInscriptionsPost, WorkshopsInscriptionsResponse } from '@/interfaces/workshop_inscription_model';
import {getWorkshopsInscriptionsByWorkshopId} from '@/services/workshop_inscriptions_api';


const props = defineProps<{
  id_workshop: number;
}>();


const workshops_inscriptions = ref<WorkshopsInscriptionsResponse[]>([]);

async function getWorkshopsInscriptionsByWorkshopIdHandler() : Promise<void> {
    try {
        
        workshops_inscriptions.value = await getWorkshopsInscriptionsByWorkshopId(props.id_workshop);
        console.log(workshops_inscriptions.value);
      
    } catch (error) {
        console.error(error);
    }
}

onMounted(getWorkshopsInscriptionsByWorkshopIdHandler);

import * as XLSX from 'xlsx';

const fileInput = ref<HTMLInputElement | null>(null);

interface ExcelData {
  rut: string;
  nota: string;
}

const processExcel = () => {
  if (fileInput.value && fileInput.value.files.length > 0) {
    const file = fileInput.value.files[0];
    const reader = new FileReader();
    
    reader.onload = (e) => {
      const data = new Uint8Array(e.target?.result as ArrayBuffer);
      const workbook = XLSX.read(data, { type: 'array' });
      const sheetName = workbook.SheetNames[0];
      const sheet = workbook.Sheets[sheetName];
      const jsonData: ExcelData[] = XLSX.utils.sheet_to_json(sheet) as ExcelData[];

      // Crear nuevo array de datos
      const result = workshops_inscriptions.value.map(item => {
        // Buscar la nota en los datos del archivo Excel subido
        const match = jsonData.find(row => row.rut === item.rut_student);
        return {
          RUT: item.rut_student,
          NOMBRE: item.name_student.split(' ')[0], // Asumiendo que el nombre está antes del apellido
          APELLIDO: item.name_student.split(' ')[1], // Asumiendo que el apellido está después del nombre
          NOTA: match ? match.nota : '', // Nota obtenida del archivo subido
          LIBRE: item.curriculum_course,
        };
      });

      // Crear y descargar nuevo archivo Excel
      const newWorkbook = XLSX.utils.book_new();
      const newWorksheet = XLSX.utils.json_to_sheet(result);
      XLSX.utils.book_append_sheet(newWorkbook, newWorksheet, 'Sheet1');
      XLSX.writeFile(newWorkbook, 'resultado.xlsx');
    };
    
    reader.readAsArrayBuffer(file);
  } else {
    alert('Por favor, selecciona un archivo Excel.');
  }
};







</script>

<style scoped lang="postcss">
 .container {
   @apply w-full m-0 p-2 border border-border rounded-3xl; 
 }
 
 .table {
   @apply min-w-full bg-background; 
 }

 .tbody {
   @apply text-foreground text-sm font-light;
 }
 
 .thead {
   @apply bg-background text-foreground uppercase text-sm leading-normal border border-transparent;
 }
 
 .th {
   @apply py-3 px-6 text-left;
 }

 .td {
   @apply py-3 px-6 text-left whitespace-nowrap;
 }
 
 .tr {
   @apply border-b border-border; 
 }

 .tr-up {
   @apply border-b border-border; 
 }

 .tr:last-child {
   @apply border-b border-transparent; 
 }

 .icon {
   @apply text-foreground;
 }

 </style>
 