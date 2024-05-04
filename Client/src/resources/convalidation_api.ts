import axios from "axios";
import type { AxiosError} from 'axios';
import type{ ConvalidationResponse } from "../models/Convalidation";


const URL = "http://localhost:8000/convalidations/";


export async function getAllConvalidation(): Promise<ConvalidationResponse[]> {
    try {
        const { data: convalidations } = await axios.get<ConvalidationResponse[]>(URL);
        console.log(convalidations);
        return convalidations;
      } 
    
      catch (error) {
        const axiosError = error as AxiosError;
        console.error('Error al obtener convalidaciones:', axiosError?.response?.data);
        throw error;
    }    
}