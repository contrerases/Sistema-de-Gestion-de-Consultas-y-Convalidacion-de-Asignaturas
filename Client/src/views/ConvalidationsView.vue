<template>
  <div>
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

