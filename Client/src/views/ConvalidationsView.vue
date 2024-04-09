<template>
  <main class="flex flex-col justify-center">
    <div v-for="convalidation in convalidations" :key="convalidation.id" class="flex flex-col items-center p-4 m-4 bg-white rounded-lg shadow-md">
      <div class="flex bg-red-500 w-6/12 h-72  rounded-2xl justify-center min-w-6xl text-left text-white font-bold font-sans text-xl">
        <div class="flex flex-col w-3/4  m-5 gap-5">
          <div class=" flex w-full h-1/4 gap-10">
          <div class="bg-red-600 w-2/5 h-full rounded-lg pl-3">
            {{convalidation.rol }}
          </div>
  
          <div class="bg-red-600 w-3/5 h-full rounded-lg pl-3">
            NOMBRE
          </div>
  
        </div>
        <div class=" w-full h-1/4">
          <div class="bg-red-600 w-full h-full rounded-lg pl-3">
            {{convalidation.id_origin_course}}
          </div>
        </div>
        <div class="w-full h-1/4">
          <div class="bg-red-600 w-full h-full rounded-lg pl-3">
            {{convalidation.id_destination_course}}
          </div>
        </div>
        <div class=" flex w-full h-1/4 justify-between">
          <div class="bg-red-600 w-5/12 h-full rounded-lg pl-3">
            {{formatReadableDate(convalidation.creation_date)}}
          </div>
          <div class="bg-red-600 w-5/12 h-full rounded-lg pl-3">
            {{formatReadableDate(convalidation.approval_date)}}
          </div>
  
  
  
        </div>
  
      </div>
      <div class="flex w-1/4 m-5 text-center">
        <div class="flex flex-col w-full h-full">
          <div class="bg-red-600 w-full h-1/4 rounded-lg mb-5 pl-3">
            {{convalidation.id}}
          </div>
  
          <div class="bg-red-600 w-full h-2/4 rounded-lg ">
            {{convalidation.state}}
          </div>
          <div class="bg-red-600 w-full h-1/4 rounded-lg mt-5 pl-3">
            BUTTON
          </div>
        </div>
      </div>
      </div>
  
    </div>
  </main>
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

