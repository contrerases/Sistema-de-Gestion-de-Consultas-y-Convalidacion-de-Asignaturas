import type  { CurriculumCourseBase } from '../models/curriculum_course_model';
import axios from "axios";
import type { AxiosError} from 'axios';



const URL = "http://localhost:8000/curriculum_courses/";


export async function getAllCurriculumCourses(): Promise<CurriculumCourseBase[]> {
    try {
        const { data: curriculum_courses } = await axios.get<CurriculumCourseBase[]>(URL);
        return curriculum_courses;
      } 
    
      catch (error) {
        const axiosError = error as AxiosError;
        console.error('Error al obtener Cursos Curriculares:', axiosError?.response?.data);
        throw error;
    }    
}

