<template>
  <div class="container mx-auto px-4 py-8">
    <div v-for="convalidation in convalidations" :key="convalidation.id" class="bg-white shadow-md rounded-md p-6 mb-4">
      <div class="grid grid-cols-2 gap-4">
        <div>
          <p class="text-gray-600"><strong>ID:</strong> {{ convalidation.id }}</p>
          <p class="text-gray-600"><strong>Rol:</strong> {{ convalidation.rol }}</p>
          <p class="text-gray-600"><strong>ID de curso de origen:</strong> {{ convalidation.id_origin_course }}</p>
          <p class="text-gray-600"><strong>ID de curso de destino:</strong> {{ convalidation.id_destination_course }}</p>
          <p class="text-gray-600"><strong>Estado:</strong> {{ convalidation.state }}</p>
        </div>
        <div>
          <p class="text-gray-600"><strong>Comentarios:</strong> {{ convalidation.comments }}</p>
          <p class="text-gray-600"><strong>Fecha de creación:</strong> {{ formatReadableDate(convalidation.creation_date ) }}</p>
          <p class="text-gray-600"><strong>Fecha de aprobación:</strong> {{ formatReadableDate(convalidation.approval_date)}}</p>
          <p class="text-gray-600"><strong>ID del usuario que aprueba:</strong> {{ convalidation.user_approves }}</p>
        </div>
      </div>
    </div>
  </div>
</template>



<script lang="ts">
import type { AxiosResponse } from 'axios';
import axios from 'axios';
import type {Convalidation} from '@/models/Convalidation'; 

export default {
  data() {
    return {
      convalidations: [] as Convalidation[] 
    };
  },
  mounted() {
    this.fetchData();
  },
  methods: {
    // Método para obtener los datos de la API
    async fetchData(): Promise<void> {
      try {
        // Realizar la solicitud GET a la API
        const response: AxiosResponse<Convalidation[]> = await axios.get('http://localhost:8000/convalidations/');
        // Asignar los datos de la respuesta a la propiedad convalidations
        this.convalidations = response.data;
        console.log(this.convalidations);
      } catch (error) {
        // Capturar y manejar errores
        console.error('Error al obtener los datos:', error);
      }
    },

      formatReadableDate(date: string | null): string {
        const settings: Intl.DateTimeFormatOptions = { 
          year: 'numeric', 
          month: 'long', 
          day: 'numeric', 
          hour: '2-digit', 
          minute: '2-digit' 
        };
        return date ? new Date(date).toLocaleDateString('es-ES', settings) : '-';
      }
  }
};
</script>

<style>
.convalidations-container {
  display: flex;
  flex-wrap: wrap;
  gap: 20px;
}

.convalidation-card {
  background-color: #f8f8f8;
  padding: 20px;
  border-radius: 10px;
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
  width: 300px;
}

.convalidation-card h3 {
  margin-top: 0;
  color: #333;
}

.convalidation-card p {
  margin: 5px 0;
  font-size: 14px;
  line-height: 1.5;
}
</style>