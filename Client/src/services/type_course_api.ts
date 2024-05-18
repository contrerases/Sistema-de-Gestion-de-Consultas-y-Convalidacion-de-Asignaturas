import type  { TypeCourseBase, TypeCourseResponse, TypeCoursePost } from '@/interfaces/type_course_model';
import axios from "axios";
import type { AxiosError} from 'axios';



const BASE_URL = "http://localhost:8000/types_courses/";


export async function getAllTypesCourses(): Promise<TypeCourseResponse[]> {
    try {
        const { data: type_courses } = await axios.get<TypeCourseResponse[]>(BASE_URL);
        return type_courses;
      } 
    
        catch (error) {
            const axiosError = error as AxiosError;
            console.error('Error al obtener Tipos de Cursos', axiosError?.response?.data);
            throw error;
        }
}



export async function deleteTypeCourse(type_course_id: number): Promise<void> {
    try {
        await axios.delete(`${BASE_URL}${type_course_id}`);
    } catch (error) {
        const axiosError = error as AxiosError;
        console.error('Error al eliminar Tipo de Curso', axiosError?.response?.data);
        throw error;
    }
}


export async function insertTypeCourse(type_course: TypeCoursePost): Promise<void> {
    try {
        await axios.post(BASE_URL, type_course);
    } catch (error) {
        const axiosError = error as AxiosError;
        console.error('Error al insertar Tipo de Curso', axiosError?.response?.data);
        throw error;
    }
}