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
import { AxiosError } from 'axios';

export default {
  data() {
    return {
      convalidations: [] as Convalidation[],
    };
  },
  mounted() {
    this.getConvalidation();
  },
  methods: {
 
    async getConvalidation(): Promise<void> {
      try {
        const response: AxiosResponse<Convalidation[]> = await axios.get('http://localhost:8000/convalidations/');
        this.convalidations = response.data;
        console.log(this.convalidations);
      } catch (error) {
        const axiosError = error as AxiosError;
        console.error('Error al obtener convalidaciones:', axiosError?.response?.data);
      }
    },
    
    async getConvalidationByState(state: string): Promise<void> {
      try {
        const response: AxiosResponse<Convalidation[]> = await axios.get(`http://localhost:8000/convalidations/state/${state}`);
        this.convalidations = response.data;
        console.log(this.convalidations);
      } catch (error) {
        const axiosError = error as AxiosError;
        console.error('Error al obtener convalidaciones:', axiosError?.response?.data || 'Error de red');
        
      }
  },

    async getConvalidationByUser(user: string): Promise<void> {
      try {
        const response: AxiosResponse<Convalidation[]> = await axios.get(`http://localhost:8000/convalidations/user/${user}`);
        this.convalidations = response.data;
      } catch (error) {
        const axiosError = error as AxiosError;
        console.error('Error al obtener convalidaciones:', axiosError?.response?.data || 'Error de red');
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

