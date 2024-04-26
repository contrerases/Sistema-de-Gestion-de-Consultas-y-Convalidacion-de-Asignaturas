<template>
  <div class=" flex justify-center flex-col max-w-screen-xl mx-auto p-10 m-10 rounded-lg border ">
    <div class="flex justify-around">
      <button class="border rounded-lg p-4 text-center bg-primary flex items-center justify-center  m-auto" @click="getConvalidation">Todas</button>
      <button class="border rounded-lg p-4 text-center bg-primary flex items-center justify-center  m-auto" @click="getConvalidationByState('Aceptada por el jefe de carrera')">Aprobadas</button>
      <button class="border rounded-lg p-4 text-center bg-primary flex items-center justify-center  m-auto" @click="getConvalidationByState('Rechazada')">Rechazadas</button>
      <button class="border rounded-lg p-4 text-center bg-primary flex items-center justify-center  m-auto" @click="getConvalidationByState('En revisión')">En revisión</button>
      <button class="border rounded-lg p-4 text-center bg-primary flex items-center justify-center  m-auto" @click="getConvalidationByState('Aceptada por dirección de estudio')">Aceptada por dirección de estudio</button>
    </div>
    <RequestCard
      v-for="convalidation in convalidations"
      :key="convalidation.id"
      :convalidation="convalidation"
    />
  </div>
</template>


<script lang="ts">
import type { AxiosResponse } from 'axios';
import axios from 'axios';
import type {Convalidation} from '@/models/Convalidation'; 
import { AxiosError } from 'axios';
import RequestCard from '@/components/RequestCard.vue';


export default {
  components: {
    RequestCard,
  },
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
    
  }
};
</script>

