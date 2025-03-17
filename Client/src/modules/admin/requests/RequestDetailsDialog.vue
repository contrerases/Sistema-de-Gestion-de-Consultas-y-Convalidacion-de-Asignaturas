<template>
  <div class="fixed inset-0 bg-black bg-opacity-50 flex justify-center items-center z-50">
    <div class="bg-white rounded-lg p-6 w-4/5 max-w-3xl shadow-lg">
      <h2 class="text-2xl font-bold mb-4">Detalles de la Solicitud</h2>

      <!-- Información de la Solicitud -->
      <p><strong>ID:</strong> {{ request.id }}</p>
      <p><strong>RUT:</strong> {{ request.rut_student }}</p>
      <p><strong>Nombre:</strong> {{ request.name_student }}</p>
      <p><strong>Campus:</strong> {{ request.campus_student }}</p>
      <p><strong>Rol:</strong> {{ request.rol_student }}</p>

      <h3 class="text-xl font-semibold mt-6 mb-4">Convalidaciones</h3>

      <!-- Tabla de Convalidaciones -->
      <table class="table-auto w-full">
        <thead>
          <tr>
            <th class="px-4 py-2">Tipo</th>
            <th class="px-4 py-2">Asignatura</th>
            <th class="px-4 py-2">Archivo</th>
            <th class="px-4 py-2">Estado</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="convalidation in request.convalidations" :key="convalidation.id">
            <td class="border px-4 py-2">{{ convalidation.convalidation_type }}</td>
            <td class="border px-4 py-2">{{ convalidation.curriculum_course }}</td>
            <td class="border px-4 py-2">
              <button
                v-if="convalidation.file_data"
                @click="downloadPdf(convalidation.file_data)"
                class="text-blue-500 underline"
              >
                {{ convalidation.file_name }}
              </button>
            </td>
            <td class="border px-4 py-2">
              <Select v-model="convalidation.state">
                <SelectTrigger>
                  <SelectValue placeholder="Estado" />
                </SelectTrigger>
                <SelectContent>
                  <SelectGroup>
                    <SelectItem value="Enviada">Enviada</SelectItem>
                    <SelectItem value="Rechazada">Rechazada</SelectItem>
                    <SelectItem value="Aprobada por DI">Aprobada por DI</SelectItem>
                  </SelectGroup>
                </SelectContent>
              </Select>
            </td>
          </tr>
        </tbody>
      </table>

      <!-- Comentario -->
      <div class="mt-6">
        <label for="comments" class="block text-lg font-semibold">Comentarios</label>
        <textarea id="comments" v-model="comment" class="w-full p-2 border rounded-md" rows="4"></textarea>
      </div>

      <!-- Botones -->
      <div class="mt-6 flex justify-end space-x-4">
        <button @click="$emit('close')" class="bg-gray-300 py-2 px-4 rounded-md">Cancelar</button>
        <button @click="submitReview" class="bg-blue-500 text-white py-2 px-4 rounded-md">Enviar</button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { defineProps, defineEmits, ref } from 'vue';
import downloadPdf from "@/helpers/download_file";

defineProps({
  request: {
    type: Object,
    required: true,
  },
});
defineEmits(['close', 'update-list']);

const comment = ref('');

// Método para enviar la revisión
const submitReview = () => {
  alert('Revisión enviada');
  emit('update-list');
  emit('close');
};
</script>
