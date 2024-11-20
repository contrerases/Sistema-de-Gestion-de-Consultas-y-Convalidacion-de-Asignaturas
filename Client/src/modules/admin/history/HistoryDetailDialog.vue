<template>
  <div v-if="isOpen" class="fixed inset-0 bg-black bg-opacity-50 flex justify-center items-center z-50">
    <div class="bg-background text-foreground p-8 rounded-xl w-[90%] max-w-4xl shadow-lg border border-border">
      <!-- Encabezado del Modal -->
      <div class="flex justify-between items-center border-b pb-4 mb-6">
        <h2 class="text-2xl font-semibold text-primary">Detalles de la Solicitud</h2>
        <button @click="closeDialog" class="text-3xl text-muted hover:text-muted-dark">
          ×
        </button>
      </div>
      
      <!-- Información de la Solicitud -->
      <div class="space-y-6">
        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
          <div class="font-semibold text-label">ID Solicitud:</div>
          <div>{{ request.id }}</div>

          <div class="font-semibold text-label">Fecha de Creación:</div>
          <div>{{ request.creation_date }}</div>

          <div class="font-semibold text-label">Fecha de Revisión:</div>
          <div>{{ request.revision_date || 'No disponible' }}</div>

          <div class="font-semibold text-label">Comentarios:</div>
          <div>{{ request.comments || 'No hay comentarios' }}</div>

          <div class="font-semibold text-label">Estado de Aprobación:</div>
          <div>{{ request.user_approver !== null ? (request.user_approver ? 'Aprobado' : 'Pendiente') : 'No Evaluado' }}</div>

          <div class="font-semibold text-label">Rol Estudiante:</div>
          <div>{{ request.rol_student }}</div>

          <div class="font-semibold text-label">Nombre Estudiante:</div>
          <div>{{ request.name_student }}</div>

          <div class="font-semibold text-label">RUT Estudiante:</div>
          <div>{{ request.rut_student }}</div>

          <div class="font-semibold text-label">Campus:</div>
          <div>{{ request.campus_student }}</div>
        </div>

        <div v-if="request.convalidations.length" class="mt-8">
          <h3 class="text-xl font-semibold text-primary">Convalidaciones</h3>
          <div class="space-y-4 mt-4">
            <div v-for="(convalidation, index) in request.convalidations" :key="convalidation.id" class="bg-background p-4 rounded-lg shadow-sm border border-border">
              <div class="flex items-center justify-between mb-4">
                <h4 class="font-semibold text-primary">Convalidación {{ index + 1 }}</h4>
                <div class="text-sm text-muted">{{ convalidation.state }}</div>
              </div>
              <div class="space-y-2">
                <div><strong class="text-label">Tipo de Convalidación:</strong> {{ convalidation.convalidation_type }}</div>
                <div><strong class="text-label">Asignatura:</strong> {{ convalidation.subject }}</div>
                <div><strong class="text-label">Curso Curricular:</strong> {{ convalidation.curriculum_course }}</div>
                <div v-if="convalidation.workshop"><strong class="text-label">Taller:</strong> {{ convalidation.workshop }}</div>
                <div v-if="convalidation.certified_course_name"><strong class="text-label">Curso Certificado:</strong> {{ convalidation.certified_course_name }}</div>
                <div v-if="convalidation.personal_project_name"><strong class="text-label">Proyecto Personal:</strong> {{ convalidation.personal_project_name }}</div>
                <div v-if="convalidation.file_name"><strong class="text-label">Archivo:</strong> {{ convalidation.file_name }}</div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Botón para Cerrar -->
      <div class="mt-6 text-right">
        <button @click="closeDialog" class="bg-primary text-white px-6 py-2 rounded-lg hover:bg-primary-dark transition-colors">
          Cerrar
        </button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { defineProps, ref } from 'vue';
import type { Request, RequestResponse } from '@/interfaces/request_model';

// Prop para recibir el estado de apertura del modal y la solicitud seleccionada
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

// Emitir un evento para cerrar el dialogo
const emit = defineEmits(['close']);

// Función para cerrar el modal
function closeDialog() {
  emit('close');
}
</script>

<style scoped lang="postcss">
/* Estilos de fondo y texto */

</style>
