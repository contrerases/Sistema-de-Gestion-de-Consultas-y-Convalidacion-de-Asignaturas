import axios from "axios";
import type { AxiosError} from 'axios';
import type{ ConvalidationResponse, ConvalidationBase, ConvalidationPost } from "@/interfaces/convalidation_model";


const apiUrl = import.meta.env.VITE_API_URL;
const BASE_URL = "http://localhost:8000/convalidations/";
const STATE_URL = BASE_URL + "state/";
const STUDENT_ROL_URL = BASE_URL + "student/";



export async function getAllConvalidations(): Promise<ConvalidationResponse[]> {
    try {
        const { data: convalidations } = await axios.get<ConvalidationResponse[]>(BASE_URL);
        return convalidations;
      } 
    
      catch (error) {
        const axiosError = error as AxiosError;
        console.error('Error al obtener convalidaciones:', axiosError?.response?.data);
        throw error;
    }    
}



export async function getConvalidationsByState(state: string): Promise<ConvalidationResponse[]> {
    try {
        const { data: convalidations } = await axios.get<ConvalidationResponse[]>(`${STATE_URL}${state}`);
        return convalidations;
    } catch (error) {
        const axiosError = error as AxiosError;
        console.error('Error al obtener convalidaciones por estado:', axiosError?.response?.data);
        throw error;
    }
}

export async function getConvalidationByID(id: number): Promise<ConvalidationResponse> {
    try {
        const { data: convalidation } = await axios.get<ConvalidationResponse>(`${BASE_URL}${id}`);
        return convalidation;
    } catch (error) {
        const axiosError = error as AxiosError;
        console.error('Error al obtener convalidación por ID:', axiosError?.response?.data);
        throw error;
    }
}

export async function getConvalidationByStudentRol(student_rol: string): Promise<ConvalidationResponse> {
    try {
        const { data: convalidation } = await axios.get<ConvalidationResponse>(`${STUDENT_ROL_URL}${student_rol}`);
        return convalidation;
    } catch (error) {
        const axiosError = error as AxiosError;
        console.error('Error al obtener convalidación por Rol:', axiosError?.response?.data);
        throw error;
    }
}


export async function insertConvalidation(convalidation: ConvalidationBase): Promise<void> {
    const formData = new FormData();
    Object.entries(convalidation).forEach(([key, value]) => {
        if (value !== null && value !== undefined) {
            formData.append(key, value);
        }
    });
  
   
   
    try {
        await axios.post(BASE_URL, formData, {
            headers: {
                'Content-Type': 'multipart/form-data',
            },
        });
  
    
    } catch (error) {
        const axiosError = error as AxiosError;
        console.error('Error al insertar convalidación:', axiosError?.response?.data);
        throw error;
    }
  
  
  }
  
  export async function updateConvalidation(convalidation: ConvalidationPost): Promise<void> {
      try {
        console.log(convalidation)
          await axios.put(BASE_URL, convalidation);
      }
      catch (error) {
          const axiosError = error as AxiosError;
          console.error('Error al actualizar convalidación:', axiosError?.response?.data);
          throw error;
      }
  }