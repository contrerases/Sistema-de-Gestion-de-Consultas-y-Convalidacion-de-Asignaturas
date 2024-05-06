import type  { WorkshopBase } from '../models/workshop_model';
import axios from "axios";
import type { AxiosError} from 'axios';



const URL = "http://localhost:8000/workshops/";


export async function getAllWorkshops(): Promise<WorkshopBase[]> {
    try {
        const { data: workshops } = await axios.get<WorkshopBase[]>(URL);
        return workshops;
      } 
    
      catch (error) {
        const axiosError = error as AxiosError;
        console.error('Error al obtener Talleres:', axiosError?.response?.data);
        throw error;
    }    
}

