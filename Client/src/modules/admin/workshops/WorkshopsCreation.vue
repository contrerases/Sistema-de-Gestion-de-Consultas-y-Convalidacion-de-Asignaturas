<template>
    <div v-if="visible" class="modal-overlay">
      <div class="modal-container">
        <!-- Formulario para añadir un nuevo taller -->
        <div>
          <h2 class="modal-title">Añadir Nuevo Taller</h2>
          
          <!-- Campo de entrada para el nombre -->
          <div class="form-group">
            <label for="name" class="form-label">Nombre del Taller:</label>
            <input type="text" id="name" v-model="workshop.name" class="form-input" />
          </div>
  
          <!-- Campo de selección para el semestre -->
          <div class="form-group">
            <label for="semester" class="form-label">Semestre:</label>
            <select id="semester" v-model="workshop.semester" class="form-input">
              <option value="1">1</option>
              <option value="2">2</option>
            </select>
          </div>
  
          <!-- Campo de entrada para el año -->
          <div class="form-group">
            <label for="year" class="form-label">Año:</label>
            <input type="number" id="year" v-model="workshop.year" class="form-input" />
          </div>
  
          <!-- Campo de entrada para el profesor -->
          <div class="form-group">
            <label for="professor" class="form-label">Profesor:</label>
            <input type="text" id="professor" v-model="workshop.professor" class="form-input" />
          </div>
  
          <!-- Campos de entrada para la fecha (día, mes, año) -->
          <div class="form-group">
            <label for="initial_date" class="form-label">Fecha Inicial:</label>
            <div class="date-inputs">
              <input type="number" v-model="day" min="1" max="31" placeholder="Día" class="form-input" />
              <input type="number" v-model="month" min="1" max="12" placeholder="Mes" class="form-input" />
              <input type="number" v-model="yearInput" min="1900" placeholder="Año" class="form-input" />
            </div>
          </div>
  
          <!-- Campo de entrada para el archivo -->
          <div class="form-group">
            <label for="file_data" class="form-label">Archivo:</label>
            <input type="file" id="file_data" @change="handleFileUpload" class="form-input" />
          </div>
  
          <!-- Campo de selección para disponibilidad -->
         
        </div>
        
        <!-- Botones de acción -->
        <div class="modal-actions">
          <button @click="saveWorkshop" class="btn-primary">Guardar</button>
          <button @click="close" class="btn-secondary">Cerrar</button>
        </div>
      </div>
    </div>
  </template>
  
  <script setup lang="ts">
  import { ref, defineProps, defineEmits, watch } from 'vue';
  import type { WorkshopPost } from '@/interfaces/workshop_model';
  import { insertWorkshop } from '@/services/workshop_api';
  

  const props = defineProps<{
      visible: boolean;
  }>();
  
  const emit = defineEmits(['close', 'insert']);


  

  

  const close = () => {
      emit('close');
  };

  const workshop = ref<WorkshopPost>({
    name: '',
    semester: '',
    year: 0,
    professor: '',
    initial_date: '',
    file_data: null,
  });
  

  const day = ref<number | null>(null);
  const month = ref<number | null>(null);
  const yearInput = ref<number | null>(null);
  

  const handleFileUpload = (event: Event) => {
    const file = (event.target as HTMLInputElement).files?.[0] || null;
    workshop.value.file_data = file;
  };
  
  
  watch([day, month, yearInput], ([newDay, newMonth, newYear]) => {
    if (newDay && newMonth && newYear) {

      workshop.value.initial_date = `${newYear}-${newMonth.toString().padStart(2, '0')}-${newDay.toString().padStart(2, '0')}`;
    }
  });
  

  const saveWorkshop = () => {
    insertWorkshopHandler();
    emit('insert');
  };

  async function insertWorkshopHandler() {
    try {
      await insertWorkshop(workshop.value);
      close();
    } catch (error) {
      console.error(error);
    }
  }



  </script>
  
  <style scoped lang="postcss">
  .modal-overlay {
    @apply fixed inset-0 bg-black bg-opacity-80 flex justify-center items-center;
  }
  
  .modal-container {
    @apply bg-background p-20 rounded-lg shadow-lg w-2/3  flex flex-col justify-between;
  }
  
  .modal-title {
    @apply text-2xl font-bold mb-4;
  }
  
  .form-group {
    @apply mb-4;
  }
  
  .form-label {
    @apply block text-sm font-medium text-foreground;
  }
  
  .form-input {
    @apply mt-1 p-2 border rounded w-full bg-input;
  }
  
  .form-checkbox {
    @apply mt-1;
  }
  
  .date-inputs {
    @apply flex space-x-2;
  }
  
  .modal-actions {
    @apply mt-4 flex justify-end;
  }
  
  .btn-primary {
    @apply bg-primary text-foreground px-4 py-2 rounded hover:bg-opacity-10 mr-2;
  }
  
  .btn-secondary {
    @apply bg-destructive text-foreground px-4 py-2 rounded hover:bg-destructive-hover ;
  }
  </style>
  