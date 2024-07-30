import axios from "axios";
import type { AxiosError} from 'axios';

import type  { TypeCurriculumCourseBase, TypeCurriculumCourseResponse } from '@/interfaces/type_curriculum_course_model';

const BASE_URL = "http://localhost:8000/types_curriculum_courses/";

export async function getAllTypesCurriculumCourses(): Promise<TypeCurriculumCourseResponse[]> {
    try {
        const { data: type_courses } = await axios.get<TypeCurriculumCourseResponse[]>(BASE_URL);
        return type_courses;
      } 
    
        catch (error) {
            const axiosError = error as AxiosError;
            console.error('Error al obtener Tipos de Cursos', axiosError?.response?.data);
            throw error;
        }
}

