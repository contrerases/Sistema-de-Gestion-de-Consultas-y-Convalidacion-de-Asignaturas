import type  { CurriculumCourseBase, CurriculumCourseResponse, CurriculumCoursePost} from '@/features/academic/curriculum/types/curriculum_course_model';
import axios from "axios";
import type { AxiosError} from 'axios';



const BASE_URL = "http://localhost:8000/curriculum_courses/";


export async function getAllCurriculumCourses(): Promise<CurriculumCourseResponse[]> {
    try {
        const { data: curriculum_courses } = await axios.get<CurriculumCourseResponse[]>(BASE_URL);
        return curriculum_courses;
      } 
      
      catch (error) {
        const axiosError = error as AxiosError;
        console.error('Error al obtener Cursos Curriculares:', axiosError?.response?.data);
        throw error;
    }    
}


export async function deleteCurriculumCourse(curriculum_course_id: number): Promise<void> {
    try {
        await axios.delete(`${URL}${curriculum_course_id}`);
    } catch (error) {
        const axiosError = error as AxiosError;
        console.error('Error al eliminar Curso Curricular:', axiosError?.response?.data);
        throw error;
    }
}



export async function insertCurriculumCourse(curriculum_course: CurriculumCoursePost): Promise<void> {
    try {
        await axios.post(BASE_URL, curriculum_course);
    } catch (error) {
        const axiosError = error as AxiosError;
        console.error('Error al insertar Curso Curricular:', axiosError?.response?.data);
        throw error;
    }
}

