import type  { TypeConvalidationBase, TypeConvalidationResponse } from '@/interfaces/type_convalidation_model';
import axios from "axios";
import type { AxiosError} from 'axios';



const BASE_URL = "http://localhost:8000/types_convalidations/";


export async function getAllTypesConvalidations(): Promise<TypeConvalidationResponse[]> {
    try {
        const { data: type_courses } = await axios.get<TypeConvalidationResponse[]>(BASE_URL);
        return type_courses;
      } 
    
        catch (error) {
            const axiosError = error as AxiosError;
            console.error('Error al obtener Tipos de Cursos', axiosError?.response?.data);
            throw error;
        }
}



export async function deleteTypeConvalidations(type_course_id: number): Promise<void> {
    try {
        await axios.delete(`${BASE_URL}${type_course_id}`);
    } catch (error) {
        const axiosError = error as AxiosError;
        console.error('Error al eliminar Tipo de Curso', axiosError?.response?.data);
        throw error;
    }
}
