import type  { TypeCourseBase } from '../models/type_course_model';
import axios from "axios";
import type { AxiosError} from 'axios';



const URL = "http://localhost:8000/types_courses/";


export async function getAllTypesCourses(): Promise<TypeCourseBase[]> {
    try {
        const { data: type_courses } = await axios.get<TypeCourseBase[]>(URL);
        return type_courses;
      } 
    
        catch (error) {
            const axiosError = error as AxiosError;
            console.error('Error al obtener Tipos de Cursos', axiosError?.response?.data);
            throw error;
        }
}