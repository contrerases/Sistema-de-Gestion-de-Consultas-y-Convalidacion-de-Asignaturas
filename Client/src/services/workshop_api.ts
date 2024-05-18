import type  { WorkshopBase, WorkshopPost, WorkshopResponse } from '@/interfaces/workshop_model';
import axios from "axios";
import type { AxiosError} from 'axios';



const URL = "http://localhost:8000/workshops/";


export async function getAllWorkshops(): Promise<WorkshopResponse[]> {
    try {
        const { data: workshops } = await axios.get<WorkshopResponse[]>(URL);
        return workshops;
      } 
    
      catch (error) {
        const axiosError = error as AxiosError;
        console.error('Error al obtener Talleres:', axiosError?.response?.data);
        throw error;
    }    
}


export async function deleteWorkshop(workshopId: number): Promise<void> {
    try {
        await axios.delete(`${URL}${workshopId}`);
    } catch (error) {
        const axiosError = error as AxiosError;
        console.error('Error al eliminar Taller:', axiosError?.response?.data);
        throw error;
    }
}


export async function insertWorkshop(workshop: WorkshopPost): Promise<void> {
    try {
        await axios.post(URL, workshop);
    } catch (error) {
        const axiosError = error as AxiosError;
        console.error('Error al insertar Taller:', axiosError?.response?.data);
        throw error;
    }
}