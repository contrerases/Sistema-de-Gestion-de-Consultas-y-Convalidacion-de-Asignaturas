import type  { SubjectResponse, SubjectBase, SubjectPost } from '@/features/academic/subjects/types/subject_model';
import axios from "axios";
import type { AxiosError} from 'axios';



const BASE_URL = "http://localhost:8000/subjects/";


export async function getAllSubject(): Promise<SubjectResponse[]> {
    try {
        const { data: subjects } = await axios.get<SubjectResponse[]>(BASE_URL);
        return subjects;
      } 
    
        catch (error) {
            const axiosError = error as AxiosError;
            console.error('Error al obtener Subjects', axiosError?.response?.data);
            throw error;
        }
}


export async function insertSubject(subject: SubjectPost): Promise<void> {
    try {
        await axios.post(BASE_URL, subject);
    } catch (error) {
        const axiosError = error as AxiosError;
        console.error('Error al insertar Subject', axiosError?.response?.data);
        throw error;
    }
}

export async function updateSubject(subject: SubjectBase): Promise<void> {
    try {
        await axios.put(BASE_URL + subject.id, subject);
    } catch (error) {
        const axiosError = error as AxiosError;
        console.error('Error al actualizar Subject', axiosError?.response?.data);
        throw error;
    }
}