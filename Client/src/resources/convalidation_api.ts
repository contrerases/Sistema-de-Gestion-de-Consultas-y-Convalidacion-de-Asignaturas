import axios from "axios";
import type { AxiosError} from 'axios';
import type{ ConvalidationResponse, ConvalidationBase, ConvalidationUpdate } from "../models/convalidation_model";



const URL = "http://localhost:8000/convalidations/";


export async function getAllConvalidation(): Promise<ConvalidationResponse[]> {
    try {
        const { data: convalidations } = await axios.get<ConvalidationResponse[]>(URL);
        return convalidations;
      } 
    
      catch (error) {
        const axiosError = error as AxiosError;
        console.error('Error al obtener convalidaciones:', axiosError?.response?.data);
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
      await axios.post(URL, formData, {
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

export async function updateConvalidation(convalidation: ConvalidationUpdate): Promise<void> {
    try {
        await axios.put(URL, convalidation);
    }
    catch (error) {
        const axiosError = error as AxiosError;
        console.error('Error al actualizar convalidación:', axiosError?.response?.data);
        throw error;
    }
}