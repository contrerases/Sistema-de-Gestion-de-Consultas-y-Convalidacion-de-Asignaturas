import type  { SubjectResponse } from '../models/subject_model';
import axios from "axios";
import type { AxiosError} from 'axios';



const URL = "http://localhost:8000/subjects/";


export async function getAllSubject(): Promise<SubjectResponse[]> {
    try {
        const { data: subjects } = await axios.get<SubjectResponse[]>(URL);
        return subjects;
      } 
    
        catch (error) {
            const axiosError = error as AxiosError;
            console.error('Error al obtener Subjects', axiosError?.response?.data);
            throw error;
        }
}