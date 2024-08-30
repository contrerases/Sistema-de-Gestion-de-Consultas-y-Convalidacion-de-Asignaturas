import type  { WorkshopsInscriptionsBase, WorkshopsInscriptionsPost, WorkshopsInscriptionsResponse} from '@/interfaces/workshop_inscription_model';
import axios from "axios";
import type { AxiosError} from 'axios';



const URL = "http://localhost:8000/workshops_inscriptions/";


// get all workshops_inscriptions by workshop_id

export async function getWorkshopsInscriptionsByWorkshopId(id_workshop: number): Promise<WorkshopsInscriptionsResponse[]> {
    try {
        const response = await axios.get(`${URL}${id_workshop}`);
        return response.data;
    } catch (error) {
        const axiosError = error as AxiosError;
        throw axiosError.response?.data;
    }
}



export async function insertWorkshopsInscriptions(workshop_inscription: WorkshopsInscriptionsPost): Promise<WorkshopsInscriptionsResponse> {
    try {
        const response = await axios.post(URL, workshop_inscription);
        return response.data;
    } catch (error) {
        const axiosError = error as AxiosError;
        throw axiosError.response?.data;
    }
}
